# Generates the synthetic Quora answer-request experiment used by the Data Practical mock.
# Everything is synthetic. Run with: Rscript make_data.R
set.seed(20260818)

N_PER_ARM <- 12000
START <- as.POSIXct("2026-08-18 00:00:00", tz = "UTC")
END   <- as.POSIXct("2026-09-01 00:00:00", tz = "UTC")   # exclusive, 14 days

# ---- writers -------------------------------------------------------------
# segment mix and, per segment: prior-90d answer range, control requests/writer,
# control answer-rate per request, treatment multipliers on each, organic answers/writer
seg <- data.frame(
  segment   = c("dormant","light","mid","heavy"),
  share     = c(0.55, 0.25, 0.15, 0.05),
  req_c     = c(0.9,  2.6,  6.0, 18.0),   # control requests per writer, 14d
  rate_c    = c(0.012, 0.075, 0.170, 0.300), # control P(answer | request)
  req_mult  = c(0.55, 0.65, 0.65, 0.55),   # treatment sends fewer
  rate_mult = c(1.60, 1.90, 1.90, 1.20),   # treatment matches better
  organic   = c(0.038, 0.40, 1.15, 2.60),  # answers not from a request, 14d
  stringsAsFactors = FALSE
)

n_total <- 2 * N_PER_ARM
segment <- sample(seg$segment, n_total, replace = TRUE, prob = seg$share)
# assignment is stratified on prior activity, so segment sizes match across arms by design
arm <- character(n_total)
for (s_ in seg$segment) {
  i <- which(segment == s_); k <- length(i)
  arm[i] <- sample(rep(c("control","treatment"), length.out = k))
}

prior <- integer(n_total)
prior[segment == "dormant"] <- 0L
prior[segment == "light"]   <- sample(1:4,  sum(segment=="light"), TRUE)
prior[segment == "mid"]     <- sample(5:19, sum(segment=="mid"),   TRUE)
prior[segment == "heavy"]   <- 20L + rgeom(sum(segment=="heavy"), 0.04)

writers <- data.frame(
  writer_id  = sprintf("w_%06d", sample(100000:999999, n_total)),
  arm        = arm,
  signup_date= as.Date("2026-08-18") - sample(30:3000, n_total, TRUE),
  prior_answers_90d = prior,
  topics_followed   = rpois(n_total, 9) + 1L,
  stringsAsFactors = FALSE
)
idx <- match(segment, seg$segment)
# within-segment concentration: most writers near 1, a thin tail well above it
act <- exp(rnorm(n_total, -0.18, 0.60))
act[segment == "heavy"] <- exp(rnorm(sum(segment == "heavy"), 0.10, 0.95))
writers$activity <- round(act, 4)

# ---- requests ------------------------------------------------------------
lam <- seg$req_c[idx] * act * ifelse(writers$arm == "treatment", seg$req_mult[idx], 1)
n_req <- rpois(n_total, lam)
req_writer <- rep(writers$writer_id, n_req)
n_r <- length(req_writer)
requests <- data.frame(
  request_id = sprintf("r_%07d", seq_len(n_r)),
  writer_id  = req_writer,
  question_id= sprintf("q_%07d", sample(1000000:9999999, n_r, TRUE)),
  sent_ts    = START + runif(n_r, 0, as.numeric(difftime(END, START, units="secs"))),
  stringsAsFactors = FALSE
)

# ---- answers -------------------------------------------------------------
p <- seg$rate_c[idx] * ifelse(writers$arm == "treatment", seg$rate_mult[idx], 1)
p_req <- pmin(p, 0.95)
ans_from_req <- rbinom(n_total, n_req, p_req[ ])          # answers to requests
ans_organic  <- rpois(n_total, seg$organic[idx] * act)           # unaffected by arm

# requested answers reuse a question_id the writer was actually asked
split_req <- split(requests$question_id, requests$writer_id)
mk_req_answers <- function(i) {
  k <- ans_from_req[i]; if (k == 0) return(NULL)
  qs <- split_req[[ writers$writer_id[i] ]]
  data.frame(writer_id = writers$writer_id[i],
             question_id = sample(qs, k), from_request = 1L, stringsAsFactors = FALSE)
}
req_ans <- do.call(rbind, lapply(which(ans_from_req > 0), mk_req_answers))
org_ans <- data.frame(
  writer_id   = rep(writers$writer_id, ans_organic),
  question_id = sprintf("q_%07d", sample(1000000:9999999, sum(ans_organic), TRUE)),
  from_request= 0L, stringsAsFactors = FALSE)
answers <- rbind(req_ans, org_ans)
answers$written_ts <- START + runif(nrow(answers), 0, as.numeric(difftime(END, START, units="secs")))
answers$upvotes_7d <- rnbinom(nrow(answers), mu = 4.1, size = 0.55)

# ---- planted issues ------------------------------------------------------
# (1) Writers appear twice with opposite arms. Assignment happened at request-send
# time, so writers with many sessions were re-randomized more often, which makes the
# bug land disproportionately on the most active writers. Not random, and it matters.
dual <- c(sample(which(segment == "heavy"), 26),
          sample(which(segment == "mid"),   10),
          sample(which(segment %in% c("light","dormant")), 4))
dup_w <- writers[dual, ]; dup_w$arm <- ifelse(dup_w$arm == "control", "treatment", "control")
writers <- rbind(writers, dup_w)

# (2) Request rows duplicated verbatim by a retry in the new routing service, so the
# duplicates sit almost entirely in the treatment arm.
trt_rows <- which(requests$writer_id %in% writers$writer_id[writers$arm == "treatment"])
ctl_rows <- setdiff(seq_len(n_r), trt_rows)
dupr <- c(sample(trt_rows, round(0.115 * length(trt_rows))),
          sample(ctl_rows, round(0.004 * length(ctl_rows))))
requests <- rbind(requests, requests[dupr, ])

# (3) answers.csv is the platform-wide table: writers outside the experiment,
#     and some answers written before the experiment started
out_ids <- sprintf("x_%06d", 1:2600)
outside <- data.frame(
  writer_id = sample(out_ids, 3400, TRUE),
  question_id = sprintf("q_%07d", sample(1000000:9999999, 3400, TRUE)),
  from_request = rbinom(3400, 1, 0.4),
  written_ts = START + runif(3400, 0, as.numeric(difftime(END, START, units="secs"))),
  upvotes_7d = rnbinom(3400, mu = 4.1, size = 0.55), stringsAsFactors = FALSE)
pre <- answers[sample(nrow(answers), 900), ]
pre$written_ts <- START - runif(900, 1, 21*86400)
answers <- rbind(answers, outside, pre)

answers$answer_id <- sprintf("a_%07d", sample(nrow(answers)))
answers <- answers[sample(nrow(answers)), c("answer_id","writer_id","question_id",
                                            "written_ts","upvotes_7d","from_request")]
requests <- requests[sample(nrow(requests)), ]
writers  <- writers[sample(nrow(writers)), ]

fmt <- function(d) { d$written_ts <- NULL; d }
answers$written_ts <- format(answers$written_ts, "%Y-%m-%d %H:%M:%S")
requests$sent_ts   <- format(requests$sent_ts,   "%Y-%m-%d %H:%M:%S")
writers$activity <- NULL
write.csv(writers,  "writers.csv",  row.names = FALSE)
write.csv(requests, "requests.csv", row.names = FALSE)
write.csv(answers,  "answers.csv",  row.names = FALSE)
cat("writers", nrow(writers), "requests", nrow(requests), "answers", nrow(answers), "\n")
