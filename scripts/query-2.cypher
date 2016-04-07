// This query list the parties that elected someone with more than 30% of the valid poll of his Constituency
// It first matches the candidates and the constituencies they run for
// Then gets this constituency and compare its 30% with the total votes of the candidate.

match (cand:CANDIDATE)-[:RAN_FOR]->(const:CONSTITUENCY)
match (cand)-[BELONGS_TO]->(p:PARTY)   
where (cand.votes > (const.turnout*1000-const.spoiled)*0.3)