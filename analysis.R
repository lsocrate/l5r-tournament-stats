source("./R/functions.R")

dusseldorf <- 1322

players <- tournament.player.sample(dusseldorf)

playerIds <- players$player_id
results <- lapply(playerIds, tournament.clan.results.for.player, validPlayerId=playerIds, tournamentId=dusseldorf)
all.results <- Reduce(rbind.data.frame, results)
clean.results <- all.results %>% dplyr::filter(!is.na(p1_clan)) %>% dplyr::filter(!is.na(p2_clan))

all.grouped <- Reduce(rbind.data.frame, lapply(clanList, group.by.result, results=clean.results))
ratio <- victory.ratio(all.grouped)

print(ratio)
