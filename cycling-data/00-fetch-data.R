library(jsonlite)

DATA_ID = "82a70e22-c7fe-4255-b283-d2d6e0a4dcd3"
APIKEY = readLines(file.path(here::here(), "apikey.txt"), warn = F)
OUTFILE = file.path(here::here(), "cycling-data", "rds", "toronto_cycling.rds")
raw_data <- data.frame()

for(x in seq(0, 1000000, by = 250)) {
  URL = paste0("https://api.namara.io/v0/data_sets/", DATA_ID, "/data/en-0?api_key=", APIKEY,
               "&offset=", x)
  tmp <- fromJSON(URL)
  if (x %% 1000 == 0) cat(".")
  if (length(tmp) == 0) break
  raw_data <- rbind(raw_data, tmp)
}

unlink("rds", recursive = TRUE)
dir.create("rds", showWarnings = FALSE)
saveRDS(raw_data, OUTFILE)