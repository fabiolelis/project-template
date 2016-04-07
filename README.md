# Irish Constituencies Neo4j Database
###### Fabio Lelis, G00330441

## Introduction
This project's objective is build a Graph Database using Neo4j and run some queries over that.
The database represents the 2016 General Elections, containing information about the 40 constituencies in the Republic of Ireland, its candidates and parties.

## Database
The first thing necessary to this project was a reliable source to provide all the information about the 2016 Elections.
After a few attempts I found it in this [RTE page](http://www.rte.ie/news/election-2016/), with a large amount of well-organised data about the Elections, separated by constituencies:

![Image of Yaktocat](https://github.com/fabiolelis/project-template/blob/master/images/rte_website.png)

How writing this information one by one would be extremely inneficient and pointless, I inspected the page looking for a document that could be read by a machine and found the link that pointed to all the information in JSON. For example, RTE has everything about the constituency of Carlow-Kilkenny  available in http://www.rte.ie/electionresults/2016/general/json/fullconstituency_c01.json.

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


![Image of Yaktocat](https://github.com/fabiolelis/project-template/blob/master/images/populate_html_ss.png)

In case of need to create the database from those scripts, first must be run create-constituencies, create-parties and create-candidates. Then all the nodes will have been created and the four create-relations scripts can be run as well (they were divided in four because apparently Neo4j got a problem executing large scripts).

Finally, I got my Graphy Database representing the elections:

![Image of Yaktocat](https://github.com/fabiolelis/project-template/blob/master/images/graphy.png)





## Queries
Summarise your three queries here.
Then explain them one by one in the following sections.

#### Query one title
This query retreives the Bacon number of an actor...
```cypher
MATCH
	(Bacon)
RETURN
	Bacon;
```

#### Query two title
This query retreives the Bacon number of an actor...
```cypher
MATCH
	(Bacon)
RETURN
	Bacon;
```

#### Query three title
This query retreives the Bacon number of an actor...
```cypher
MATCH
	(Bacon)
RETURN
	Bacon;
```

## References
1. [Neo4J website](http://neo4j.com/), the website of the Neo4j database.
2. [RTE website](http://www.rte.ie/news/election-2016/), all information about 2016 Irish General Elections RTE page
