# Data for Data Practical case 02: the Add Question flow funnel test.
# Everything synthetic. Base R only. Run with: Rscript make_data.R
set.seed(20260901)

N_PER_ARM <- 25000
START <- as.POSIXct("2026-09-01 00:00:00", tz="UTC")
END   <- as.POSIXct("2026-09-15 00:00:00", tz="UTC")   # 14 days, exclusive
SECS  <- as.numeric(difftime(END, START, units="secs"))

n <- 2*N_PER_ARM
arm <- sample(rep(c("control","treatment"), each=N_PER_ARM))
platform <- sample(c("ios","android","web"), n, TRUE, prob=c(0.42,0.26,0.32))
prior_q  <- rpois(n, 0.8)                                  # pre-treatment: questions asked in prior 90d
uid <- sprintf("u_%07d", sample(1000000:9999999, n))

assign <- data.frame(assignment_id=sprintf("as_%07d", seq_len(n)), user_id=uid, arm=arm,
                     platform=platform, prior_questions_90d=prior_q,
                     assigned_ts=START+runif(n,0,SECS), stringsAsFactors=FALSE)

trt <- arm=="treatment"
# funnel probabilities, conditional on the previous step
p_open   <- rep(0.990, n)                                  # true render rate, same both arms
p_type   <- ifelse(trt, 0.727, 0.727)                      # typing unaffected
p_shown  <- ifelse(trt, 0.956, 0.917)                      # better model surfaces more often
p_click  <- ifelse(trt, 0.150, 0.080)                      # the treatment effect
p_post_noclick <- ifelse(trt, 0.585, 0.590)
p_post_click   <- ifelse(trt, 0.462, 0.669)                # clickers post much less in treatment

opened <- rbinom(n,1,p_open)==1
typed  <- opened & rbinom(n,1,p_type)==1
shown  <- typed  & rbinom(n,1,p_shown)==1
clicked<- shown  & rbinom(n,1,p_click)==1
posted <- ifelse(clicked, rbinom(n,1,p_post_click)==1,
                 typed & rbinom(n,1,p_post_noclick)==1)
# of clickers who did not post, who came back to ask again within 7 days
reask <- clicked & !posted & rbinom(n,1,ifelse(trt,0.25,0.30))==1

chars <- ifelse(typed, round(rlnorm(n, 3.4, 0.55)), NA)
# ---- PLANTED 3: on web the character counter fails for about a fifth of typed
# events, so chars_typed is NA on rows that definitely had typing. mean() returns NA.
chars[typed & platform=="web" & runif(n) < 0.21] <- NA

ev <- function(mask, name, tsoff) {
  i <- which(mask)
  data.frame(user_id=assign$user_id[i], event_name=name,
             event_ts=assign$assigned_ts[i]+tsoff[i],
             platform=assign$platform[i],
             chars_typed=if (name=="ask_type") chars[i] else NA_real_,
             stringsAsFactors=FALSE)
}
o1<-runif(n,1,4); o2<-o1+runif(n,2,30); o3<-o2+runif(n,0.2,2)
o4<-o3+runif(n,1,20); o5<-o2+runif(n,10,300); o6<-o5+runif(n,86400,7*86400)
events <- rbind(ev(opened,"ask_open",o1), ev(typed,"ask_type",o2),
                ev(shown,"suggest_shown",o3), ev(clicked,"suggest_click",o4),
                ev(posted,"ask_post",o5), ev(reask,"ask_reopen_7d",o6))

# ---- PLANTED 1: on iOS, treatment logs ask_open only after the suggestion model
# returns, so treatment users who bail in the first ~2.5s never log it. Server-side
# assignment is complete; the client funnel's top step is not.
bail <- with(assign, platform=="ios" & arm=="treatment") & opened & o1 < 2.5 & !typed
drop <- events$event_name=="ask_open" & events$user_id %in% assign$user_id[bail]
events <- events[!drop, ]

# ---- PLANTED 2: the log is platform-wide, so it carries users outside the experiment
out <- data.frame(user_id=sprintf("x_%06d",1:1900), event_name=sample(c("ask_open","ask_type","ask_post"),1900,TRUE),
                  event_ts=START+runif(1900,0,SECS), platform=sample(c("ios","android","web"),1900,TRUE),
                  chars_typed=NA_real_, stringsAsFactors=FALSE)
events <- rbind(events, out)

events$event_id <- sprintf("e_%08d", sample(nrow(events)))
events <- events[sample(nrow(events)), c("event_id","user_id","event_name","event_ts","platform","chars_typed")]
events$event_ts    <- format(events$event_ts, "%Y-%m-%d %H:%M:%S")
assign$assigned_ts <- format(assign$assigned_ts, "%Y-%m-%d %H:%M:%S")
assign <- assign[sample(nrow(assign)), ]

write.csv(assign, "assignments.csv", row.names=FALSE)
write.csv(events, "events.csv",      row.names=FALSE)
cat("assignments", nrow(assign), " events", nrow(events),
    " ask_open dropped", sum(drop), "\n")
