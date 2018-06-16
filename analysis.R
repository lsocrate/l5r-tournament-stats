source("./R/functions.R")

# tournament.id <- 1322 # Duesseldorf
# tournament.id <- 1459 # Birmingham Day 1A
# tournament.id <- 1461 # Birmingham Day 1B
tournament.id <- 1588 # Bologna

players <- tournament.player.sample(tournament.id)

playerIds <- players$player_id
results <- lapply(playerIds, tournament.clan.results.for.player, validPlayerId=playerIds, tournamentId=tournament.id)
all.results <- Reduce(rbind.data.frame, results)
clean.results <- all.results %>% dplyr::filter(!is.na(p1_clan)) %>% dplyr::filter(!is.na(p2_clan))

all.grouped <- Reduce(rbind.data.frame, lapply(clanList, group.by.result, results=clean.results))
ratio <- victory.ratio(all.grouped)

dir.create(file.path("output"), showWarnings = FALSE)
write.csv(ratio, file.path("output", "win-ratio.csv"))
