//General score
//The parties who got a seat, ranked by number votes and seats, with percentages.
//And how many votes they need to get one seat.

//Gets the total numbers of seats and votes.
//Then groups by party
//Returns each party that got any seats, its votes, its percentage of seats and votes, its "votes-per-seat"

match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY) where p.seats > 0
with sum(cand.votes) as totalVotes, sum(p.seats) as totalSeats
match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY) where p.seats > 0
return p.name, sum(cand.votes), sum(p.seats), 100*sum(cand.votes)/totalVotes, 100*sum(cand.seats)/totalSeats, sum(cand.votes)/sum(p.seats)
order by sum(cand.votes) desc