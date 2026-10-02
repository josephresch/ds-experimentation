# Data for Data Practical case 03: onboarding change, ramped rollout, retention outcome.
# Everything synthetic. Base R only. Run with: Rscript make_data.R
set.seed(20260915)

DAY1  <- as.Date("2026-08-03")     # first signup day
ENROL <- 28                        # signups accepted on days 1..28
PULL  <- DAY1 + 34                 # data pulled on day 35: most users are censored

# ---- ramped rollout: 10% treatment for the first 7 days, then 50/50 -------
per_day <- round(rnorm(ENROL, 860, 70))
day <- rep(1:ENROL, per_day); n <- length(day)
p_trt <- ifelse(day <= 7, 0.10, 0.50)
arm <- ifelse(runif(n) < p_trt, "treatment", "control")

users <- data.frame(
  user_id      = sprintf("n_%06d", sample(100000:999999, n)),
  arm          = arm,
  signup_date  = DAY1 + day - 1,
  platform     = sample(c("ios","android","web"), n, TRUE, prob=c(0.38,0.30,0.32)),
  country_group= sample(c("US","IN","other"), n, TRUE, prob=c(0.42,0.18,0.40)),
  stringsAsFactors = FALSE)
users$days_observed <- as.integer(PULL - users$signup_date)

# ---- weekly session intensity: the effect is front-loaded and decays -------
trt <- arm == "treatment"
mu  <- cbind(w1 = ifelse(trt, 4.00, 3.20),
             w2 = ifelse(trt, 2.00, 1.90),
             w3 = ifelse(trt, 1.42, 1.40),
             w4 = ifelse(trt, 1.16, 1.15))
act <- exp(rnorm(n, -0.10, 0.75))                 # per-user activity multiplier, heavy tail
act[sample(n, round(0.004*n))] <- exp(rnorm(round(0.004*n), 2.2, 0.5))   # a few very heavy users

sess <- matrix(0L, n, 4)
for (w in 1:4) sess[, w] <- rnbinom(n, mu = mu[, w] * act, size = 1.5)

# a week only produces sessions if the user was observed through it
obs_weeks <- pmin(4L, users$days_observed %/% 7L)
for (w in 1:4) sess[obs_weeks < w, w] <- 0L

# ---- long sessions table -------------------------------------------------
rows <- lapply(1:4, function(w) {
  k <- sess[, w]; i <- rep(seq_len(n), k)
  if (!length(i)) return(NULL)
  data.frame(user_id = users$user_id[i],
             session_date = users$signup_date[i] + (w-1)*7 + sample(0:6, length(i), TRUE),
             week = w, stringsAsFactors = FALSE)
})
sessions <- do.call(rbind, rows)
sessions <- sessions[sessions$session_date <= PULL, ]
sessions$session_id <- sprintf("s_%07d", sample(nrow(sessions)))
sessions <- sessions[sample(nrow(sessions)), c("session_id","user_id","session_date")]

users <- users[sample(nrow(users)), ]
write.csv(users,    "users.csv",    row.names = FALSE)
write.csv(sessions, "sessions.csv", row.names = FALSE)
cat("users", nrow(users), " sessions", nrow(sessions),
    " fully observed (>=28d)", sum(users$days_observed >= 28), "\n")
cat("arm x ramp:\n"); print(table(users$arm, ifelse(users$signup_date < DAY1+7, "days1_7", "days8_28")))
