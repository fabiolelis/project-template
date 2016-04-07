// Candidates in one of those two largest parties (Fianna Fáil or Fine Gael) that get less than 2500 votes

// Gets who did less than 2500 votes even in a greater party (P01 or P03)

match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY)
where cand.votes < 2500
and (p.party_id = "P01" or p.party_id = "P03")
return cand, p