# Irish Constituencies Neo4j Database
###### Fabio Lelis, G00330441

## Introduction
This project's objective is build a Graph Database using Neo4j and run some queries over that.
The database represents the 2016 General Elections, containing information about the 40 constituencies in the Republic of Ireland, its candidates and parties.

## Database
The first thing necessary to this project was a reliable source to provide all the information about the 2016 Elections.
After a few attempts I found it in this [RTE page](http://www.rte.ie/news/election-2016/), with a large amount of well-organised data about the Elections, separated by constituencies:

![RTE page](https://github.com/fabiolelis/project-template/blob/master/images/rte_website.png)

As writing this information one by one would be extremely inneficient and pointless, I inspected the page looking for a document that could be read by a machine and found the link that pointed to all the information in JSON. For example, RTE has everything about the constituency of Carlow-Kilkenny  available in http://www.rte.ie/electionresults/2016/general/json/fullconstituency_c01.json.


Once I had this I wrote an algorithm to generate the scripts to create the database. Then, I put this on this html file ([Populate](https://github.com/fabiolelis/project-template/blob/master/supports/populate.html)) and used this to get the scripts and store them at the [supports](https://github.com/fabiolelis/project-template/tree/master/supports) folder.

A code snippet that shows how I get a script to insert the constituencies:

```javascript
	var text = "CREATE <br/>";

	$.each(elections, function( index, election ) {

		if(index > 0)
			text += ' <br/>,';
	  	text += ('(constituency' + index + ':CONSTITUENCY {');
	  	text += ('const_id: "' + election.SUMMARY.CONSTITUENCY +  '", ');
	  	text += ('name: "'+ election.SUMMARY.CONSTITUECY_SHORT_NAME +  '", ');
	  	text += ('electorate: '+ election.SUMMARY.ELECTORATE.replace(",",".") +  ', ');
	  	text += ('num_candidates: '+ election.SUMMARY.NOCANDIDATES +  ', ');
	  	text += ('num_seats: '+ election.SUMMARY.NOSEATS +  ', ');
	  	text += ('turnout: '+ election.SUMMARY.TURNOUT.replace(",",".")  +  ', ');
	  	text += ('spoiled: '+ election.SUMMARY.SPOILED.replace(",",".")  +  ' ');


	  	text += '})';

	});


	$("#divText").html(text);

```


![Populate html](https://github.com/fabiolelis/project-template/blob/master/images/populate_html_ss.png)

In case of need to create the database from those scripts, first must be run create-constituencies, create-parties and create-candidates. Then all the nodes will have been created and the four create-relations scripts can be run as well (they were divided in four because apparently Neo4j got a problem executing large scripts).

Finally, I got my Graphy Database representing the elections:

![Graphy](https://github.com/fabiolelis/project-template/blob/master/images/graphy.png)

The database, briefly, has: 40 nodes representing Constituencies, 550 nodes representing Candidates, 385 nodes representing regionally Parties (by constituency), 550 relationships "ran for" and 500 relationships "belongs to" between the Candidates and their Constituency and their Parties respectively.

Example of one candidate and his relationships:  
![Candidate](https://github.com/fabiolelis/project-template/blob/master/images/cand1.png)
![Details](https://github.com/fabiolelis/project-template/blob/master/images/cand1detail.png)

## Queries
The three following queries is a try of give some meaningful information about the Elections and the new composition of the seats.

#### General score
The parties who got a seat, ranked by number votes and seats, with percentages.
And how many votes they needed to get one seat.

```cypher
match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY) where p.seats > 0
with sum(cand.votes) as totalVotes, sum(p.seats) as totalSeats
match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY) where p.seats > 0
return p.name, sum(cand.votes), sum(p.seats), 100*sum(cand.votes)/totalVotes, 100*sum(cand.seats)/totalSeats, sum(cand.votes)/sum(p.seats)
order by sum(cand.votes) desc
```
Output:
![Query1](https://github.com/fabiolelis/project-template/blob/master/images/query1.png)

#### Thirty percent of votes
This query list the parties that elected someone with more than 30% of the valid poll of his Constituency

```cypher
match (cand:CANDIDATE)-[:RAN_FOR]->(const:CONSTITUENCY)
match (cand)-[BELONGS_TO]->(p:PARTY)   
where (cand.votes > (const.turnout*1000-const.spoiled)*0.3)

return DISTINCT p.name
```

Output:
![Query 2](https://github.com/fabiolelis/project-template/blob/master/images/query2.png)

#### Major party: not that good, though
Candidates in one of those two largest parties (Fianna Fáil or Fine Gael) that get less than 2500 votes

```cypher
match (cand:CANDIDATE)-[:BELONGS_TO]->(p:PARTY)
where cand.votes < 2500
and (p.party_id = "P01" or p.party_id = "P03")
return cand, p
```

Output:
![Query 3](https://github.com/fabiolelis/project-template/blob/master/images/query3.png)

## References
1. [Neo4J website](http://neo4j.com/), the website of the Neo4j database.
2. [RTE website](http://www.rte.ie/news/election-2016/), all information about 2016 Irish General Elections RTE page
3. [Agregation](http://neo4j.com/docs/stable/query-aggregation.html)
4. [Order by](http://neo4j.com/docs/stable/query-order.html)
5. [With](http://stackoverflow.com/questions/18975647/neo4j-cypher-query-to-return-relationship-property-and-sum-of-all-matching-relat)
