library(jsonlite)
library(dplyr)

clanList <- c( "Crab" ,"Crane"    ,"Dragon"   ,"Lion"     ,"Phoenix"  ,"Scorpion" ,"Unicorn" )

tournament.player.sample <- function (tournamentId) {
  ranking <- fromJSON(paste0("http://thelotuspavilion.com/api/v3/tournaments/", tournamentId, "?swiss_order=1"), simplifyDataFrame=TRUE)
  player.sampleSize <- round(2 * nrow(ranking)/3)
  ranking[1:player.sampleSize,]
}

tournament.clan.results.for.player <- function(validPlayerIds, tournamentId, playerId) {
  matches <- fromJSON(paste0("http://thelotuspavilion.com/api/v3/games?swiss_only=1&tournament_id=", tournamentId, "&player_id=", playerId), simplifyDataFrame = TRUE)
  matches %>%
    filter(p1_id %in% validPlayerIds || p2_id %in% validPlayerIds) %>%
    mutate(winner_clan = ifelse( p1_points > p2_points, p1_clan, p2_clan))  %>%
    select(p1_clan, p2_clan, winner_clan)
}

group.by.result <- function (clan, results) {
  p1 <- results[results$p1_clan == clan,] %>% mutate(won = winner_clan == p1_clan, target = p1_clan, opponent = p2_clan) %>% select(won, target, opponent)
  p2 <- results[results$p2_clan == clan,] %>% mutate(won = winner_clan == p2_clan, target = p2_clan, opponent = p1_clan) %>% select(won, target, opponent)
  rbind.data.frame(p1, p2)
}

victory.ratio <- function(grouped.by.results) {
  grouped.by.results %>% group_by(target, opponent) %>% summarise(victory.rate = sum(won)/n())
}
