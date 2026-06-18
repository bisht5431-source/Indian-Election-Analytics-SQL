-- PostgreSQL CREATE TABLE Script

CREATE TABLE state_results (
    Constituency VARCHAR(100),
    Const_No INTEGER,
    Parliament_Const VARCHAR(100) Primary Key,
    Leading_Candidate VARCHAR(100),
    Trailing_Candidate VARCHAR(100),
    Margin INTEGER,
    Status VARCHAR(100),
    State_ID VARCHAR(100),
    States VARCHAR(100)
);


CREATE TABLE const_results (
    S_N INTEGER,
    Parliament_Const VARCHAR(100) Primary Key,
    Const_Name VARCHAR(100),
    Winning_Candidate VARCHAR(100),
    Total_Votes INTEGER,
    Margin INTEGER,
    Const_ID VARCHAR(100),
    Party_ID INTEGER
);

Drop Table If Exists const_details;
CREATE TABLE const_details (
    S_N INTEGER,
    Candidate VARCHAR(100),
    Party VARCHAR(100),
    EVM_Votes INTEGER,
    Postal_Votes INTEGER,
    Total_Votes INTEGER,
    Votes_percent NUMERIC(18,2),
    Const_ID VARCHAR(100)
);

CREATE TABLE states (
    State_ID VARCHAR(100) Primary Key,
    States VARCHAR(100)
);

CREATE TABLE party_results (
    Party VARCHAR(100),
    Won INTEGER,
    Party_ID INTEGER Primary Key
);

Select * From const_details;

Select * From const_results;

Select * From party_results;

Select * From state_results;

Select * From states;


--- Find Total Seats?
Select 
	Distinct Count(Parliament_Const) As Total_seats
From const_results;


--- What is the total number of seats available for elections in each state?
Select 
	s.states As State_name,
	Count(cr.parliament_Const) As Total_seats
From const_results cr
Inner Join state_results sr On cr.Parliament_Const = sr.Parliament_Const
Inner Join states s On sr.state_id = s.state_id
Group By s.states
Order By Total_seats Desc;


--- Total Seats Won by NDA Allianz
SELECT
    SUM(CASE
            WHEN Party IN (
                'Bharatiya Janata Party - BJP',
                'Telugu Desam - TDP',
                'Janata Dal  (United) - JD(U)',
                'Shiv Sena - SHS',
                'AJSU Party - AJSUP',
                'Apna Dal (Soneylal) - ADAL',
                'Asom Gana Parishad - AGP',
                'Hindustani Awam Morcha (Secular) - HAMS',
                'Janasena Party - JnP',
                'Janata Dal  (Secular) - JD(S)',
                'Lok Janshakti Party(Ram Vilas) - LJPRV',
                'Nationalist Congress Party - NCP',
                'Rashtriya Lok Dal - RLD',
                'Sikkim Krantikari Morcha - SKM'
            )
            THEN Won
            ELSE 0
        END
    ) AS nda_total_seats_won
FROM party_results;


-- Seats Won by NDA Allianz Parties
SELECT
    Party AS Party_Name,
    Won AS Seats_Won
FROM
    party_results
WHERE
    Party IN (
        'Bharatiya Janata Party - BJP',
        'Telugu Desam - TDP',
        'Janata Dal  (United) - JD(U)',
        'Shiv Sena - SHS',
        'AJSU Party - AJSUP',
        'Apna Dal (Soneylal) - ADAL',
        'Asom Gana Parishad - AGP',
        'Hindustani Awam Morcha (Secular) - HAMS',
        'Janasena Party - JnP',
        'Janata Dal  (Secular) - JD(S)',
        'Lok Janshakti Party(Ram Vilas) - LJPRV',
        'Nationalist Congress Party - NCP',
        'Rashtriya Lok Dal - RLD',
        'Sikkim Krantikari Morcha - SKM'
    )
ORDER BY Won DESC;


--- Total Seats Won by I.N.D.I.A. Allianz
SELECT
    SUM(Won) AS india_total_seats_won
FROM party_results
WHERE Party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);


---Seats Won by I.N.D.I.A. Allianz Parties
SELECT
    Party AS party_name,
    Won AS seats_won
FROM party_results
WHERE Party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
)
ORDER BY Won DESC;


--Add new column field in table party_results to get the Party Allianz as NDA, I.N.D.I.A and OTHER
Alter Table party_results
Add party_allianz Varchar(100);

----I.N.D.I.A Allianz
UPDATE party_results
SET party_allianz = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
    'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);

----NDA Allianz
UPDATE party_results
SET party_allianz = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);


---OTHER
UPDATE party_results
SET party_allianz = 'OTHER'
WHERE party_allianz IS NULL;


---Which party alliance (NDA, I.N.D.I.A, or OTHER) won the most seats across all states?
Select 
	party_allianz,
	Sum(Won) As Total_seats
From party_results
Group By party_allianz
Order By total_seats Desc;


--Winning candidate's name, their party name, total votes, and the margin of 
--victory for a specific state and constituency?
Select 
	cr.winning_candidate,
	pr.party,
	pr.party_allianz,
	cr.total_votes,
	cr.margin,
	s.states,
	cr.const_name
From const_results cr
Inner Join party_results pr
On cr.party_id = pr.party_id
Inner Join state_results sr 
On cr.parliament_const = sr.parliament_const
Inner Join states s
On sr.state_id = s.state_id
Where cr.const_name = 'GHAZIABAD';


--- What is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
Select
	cd.evm_votes,
	cd.postal_votes,
	cd.total_votes,
	cd.candidate,
	cr.const_name
From const_results cr
Join const_details cd On cr.const_id = cd.const_id
Where cr.const_name = 'AMETHI';


--Which parties won the most seats in s State, and how many seats did each party win?
SELECT 
    p.Party,
    COUNT(cr.Const_ID) AS Seats_Won
FROM 
    const_results cr
JOIN 
    party_results p ON cr.Party_ID = p.Party_ID
JOIN 
    state_results sr ON cr.Parliament_Const = sr.Parliament_Const
JOIN states s ON sr.State_ID = s.State_ID
WHERE 
    s.stateS = 'Andhra Pradesh'
GROUP BY 
    p.Party
ORDER BY 
    Seats_Won DESC;


-- What is the total number of seats won by each party alliance (NDA, I.N.D.I.A, and OTHER) 
-- in each state for the India Elections 2024
SELECT 
    s.States AS State_Name,
    SUM(CASE WHEN p.party_allianz = 'NDA' THEN 1 ELSE 0 END) AS NDA_Seats_Won,
    SUM(CASE WHEN p.party_allianz = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
	SUM(CASE WHEN p.party_allianz = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
FROM const_results cr
JOIN party_results p ON cr.Party_ID = p.Party_ID
JOIN state_results sr ON cr.Parliament_Const = sr.Parliament_Const
JOIN states s ON sr.State_ID = s.State_ID
WHERE p.party_allianz IN ('NDA', 'I.N.D.I.A', 'OTHER') 
GROUP BY s.states
ORDER BY s.States;


--Which candidate received the highest number of EVM votes in each constituency (Top 10)?
SELECT
    cr.Const_Name,
    cd.Const_ID,
    cd.Candidate,
    cd.EVM_Votes 
FROM const_details cd
JOIN const_results cr ON cd.Const_ID = cr.Const_ID
WHERE cd.EVM_Votes = (
    SELECT MAX(cd1.EVM_Votes)
    FROM const_details cd1
    WHERE cd1.Const_ID = cd.Const_ID
)
ORDER BY cd.EVM_Votes DESC
LIMIT 10;


--- Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
WITH RankedCandidates AS (
    SELECT
        cd.Const_ID,
        cr.Const_Name,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        (cd.EVM_Votes + cd.Postal_Votes) AS total_votes,
        ROW_NUMBER() OVER (
            PARTITION BY cd.Const_ID
            ORDER BY (cd.EVM_Votes + cd.Postal_Votes) DESC
        ) AS vote_rank
    FROM const_details cd
    JOIN const_results cr
        ON cd.Const_ID = cr.Const_ID
    JOIN state_results sr
        ON cr.Parliament_Const = sr.Parliament_Const
    JOIN states s
        ON sr.State_ID = s.State_ID
    WHERE s.States = 'Maharashtra'
)

SELECT
    Const_Name,
    MAX(
        CASE
            WHEN vote_rank = 1 THEN Candidate
        END
    ) AS winning_candidate,
    MAX(
        CASE
            WHEN vote_rank = 2 THEN Candidate
        END
    ) AS runnerup_candidate
FROM RankedCandidates
GROUP BY Const_Name
ORDER BY Const_Name;

