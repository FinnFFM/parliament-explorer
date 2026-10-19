CREATE TABLE sessions(id TEXT PRIMARY KEY,term INTEGER,number INTEGER,date TEXT,duration_minutes INTEGER,source TEXT);
CREATE TABLE speeches(id TEXT PRIMARY KEY,session_id TEXT,position INTEGER,speaker_id TEXT,speaker TEXT,faction TEXT,agenda TEXT,text TEXT,comments TEXT,word_count INTEGER);
CREATE VIRTUAL TABLE speech_search USING fts5(id UNINDEXED,speaker,text,tokenize='unicode61 remove_diacritics 2');
PRAGMA user_version=1;
INSERT INTO sessions VALUES('WP99-1',99,1,'2025-02-12',90,'demo-1.xml');
INSERT INTO sessions VALUES('WP99-2',99,2,'2025-03-12',90,'demo-2.xml');
INSERT INTO sessions VALUES('WP99-3',99,3,'2025-04-12',90,'demo-3.xml');
INSERT INTO speeches VALUES('DEMO-1-1','WP99-1',1,'demo-a','Mara Linden','Forum','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','["(Beifall in der Beispielgruppe.)"]',49);
INSERT INTO speech_search VALUES('DEMO-1-1','Mara Linden','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-1-2','WP99-1',2,'demo-b','Jonas Berg','Dialog','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','[]',40);
INSERT INTO speech_search VALUES('DEMO-1-2','Jonas Berg','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
INSERT INTO speeches VALUES('DEMO-1-3','WP99-1',3,'demo-c','Lea Winter','Perspektive','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','["(Beifall in der Beispielgruppe.)"]',38);
INSERT INTO speech_search VALUES('DEMO-1-3','Lea Winter','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-1-4','WP99-1',4,'demo-d','Amir Sommer','Forum','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','[]',36);
INSERT INTO speech_search VALUES('DEMO-1-4','Amir Sommer','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-1-5','WP99-1',5,'demo-a','Mara Linden','Forum','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','["(Beifall in der Beispielgruppe.)"]',49);
INSERT INTO speech_search VALUES('DEMO-1-5','Mara Linden','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-1-6','WP99-1',6,'demo-b','Jonas Berg','Dialog','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','[]',40);
INSERT INTO speech_search VALUES('DEMO-1-6','Jonas Berg','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
INSERT INTO speeches VALUES('DEMO-1-7','WP99-1',7,'demo-c','Lea Winter','Perspektive','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','["(Beifall in der Beispielgruppe.)"]',38);
INSERT INTO speech_search VALUES('DEMO-1-7','Lea Winter','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-1-8','WP99-1',8,'demo-d','Amir Sommer','Forum','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','[]',36);
INSERT INTO speech_search VALUES('DEMO-1-8','Amir Sommer','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-2-1','WP99-2',1,'demo-a','Mara Linden','Forum','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','["(Beifall in der Beispielgruppe.)"]',40);
INSERT INTO speech_search VALUES('DEMO-2-1','Mara Linden','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
INSERT INTO speeches VALUES('DEMO-2-2','WP99-2',2,'demo-b','Jonas Berg','Dialog','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','[]',38);
INSERT INTO speech_search VALUES('DEMO-2-2','Jonas Berg','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-2-3','WP99-2',3,'demo-c','Lea Winter','Perspektive','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','["(Beifall in der Beispielgruppe.)"]',36);
INSERT INTO speech_search VALUES('DEMO-2-3','Lea Winter','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-2-4','WP99-2',4,'demo-d','Amir Sommer','Forum','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','[]',49);
INSERT INTO speech_search VALUES('DEMO-2-4','Amir Sommer','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-2-5','WP99-2',5,'demo-a','Mara Linden','Forum','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','["(Beifall in der Beispielgruppe.)"]',40);
INSERT INTO speech_search VALUES('DEMO-2-5','Mara Linden','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
INSERT INTO speeches VALUES('DEMO-2-6','WP99-2',6,'demo-b','Jonas Berg','Dialog','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','[]',38);
INSERT INTO speech_search VALUES('DEMO-2-6','Jonas Berg','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-2-7','WP99-2',7,'demo-c','Lea Winter','Perspektive','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','["(Beifall in der Beispielgruppe.)"]',36);
INSERT INTO speech_search VALUES('DEMO-2-7','Lea Winter','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-2-8','WP99-2',8,'demo-d','Amir Sommer','Forum','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','[]',49);
INSERT INTO speech_search VALUES('DEMO-2-8','Amir Sommer','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-3-1','WP99-3',1,'demo-a','Mara Linden','Forum','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','["(Beifall in der Beispielgruppe.)"]',38);
INSERT INTO speech_search VALUES('DEMO-3-1','Mara Linden','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-3-2','WP99-3',2,'demo-b','Jonas Berg','Dialog','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','[]',36);
INSERT INTO speech_search VALUES('DEMO-3-2','Jonas Berg','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-3-3','WP99-3',3,'demo-c','Lea Winter','Perspektive','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','["(Beifall in der Beispielgruppe.)"]',49);
INSERT INTO speech_search VALUES('DEMO-3-3','Lea Winter','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-3-4','WP99-3',4,'demo-d','Amir Sommer','Forum','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','[]',40);
INSERT INTO speech_search VALUES('DEMO-3-4','Amir Sommer','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
INSERT INTO speeches VALUES('DEMO-3-5','WP99-3',5,'demo-a','Mara Linden','Forum','Digitale Verwaltung','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.','["(Beifall in der Beispielgruppe.)"]',38);
INSERT INTO speech_search VALUES('DEMO-3-5','Mara Linden','Eine digitale Verwaltung soll Zeit sparen und allen Menschen offenstehen. Verständliche Formulare, Datenschutz und offene Standards gehören zusammen. Persönliche Beratung bleibt wichtig.

Öffentliche Software muss überprüfbar sein. Gemeinsame Schnittstellen vermeiden doppelte Arbeit und erleichtern den Austausch zwischen Gemeinden.');
INSERT INTO speeches VALUES('DEMO-3-6','WP99-3',6,'demo-b','Jonas Berg','Dialog','Bildung und Forschung','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.','[]',36);
INSERT INTO speech_search VALUES('DEMO-3-6','Jonas Berg','Bildung eröffnet neue Möglichkeiten. Schulen brauchen gute Räume, ausreichend Personal und verlässliche Ausstattung. Forschung lebt von Neugier und internationalem Austausch.

Wir wollen langfristige Investitionen ermöglichen. Dazu gehören Bibliotheken, Weiterbildung und ein leichterer Zugang zu wissenschaftlichen Ergebnissen.');
INSERT INTO speeches VALUES('DEMO-3-7','WP99-3',7,'demo-c','Lea Winter','Perspektive','Mobilität und öffentlicher Verkehr','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.','["(Beifall in der Beispielgruppe.)"]',49);
INSERT INTO speech_search VALUES('DEMO-3-7','Lea Winter','Eine zuverlässige Bahn verbindet Menschen. Wir wollen kurze Wege, sichere Radwege und einen öffentlichen Verkehr, der auch auf dem Land erreichbar bleibt. Investitionen brauchen klare Ziele und transparente Kosten.

Wir müssen Fahrpläne besser abstimmen und Barrieren abbauen. Gute Mobilität beginnt an der nächsten Haltestelle, nicht erst am großen Bahnhof.');
INSERT INTO speeches VALUES('DEMO-3-8','WP99-3',8,'demo-d','Amir Sommer','Forum','Energie und Klimaschutz','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.','[]',40);
INSERT INTO speech_search VALUES('DEMO-3-8','Amir Sommer','Die Energiewende braucht verlässliche Netze und bezahlbare Preise. Kommunen sollen an erneuerbaren Energien beteiligt werden. Planung und Naturschutz müssen gemeinsam gedacht werden.

Wir schlagen vor, Fortschritte jährlich zu veröffentlichen. Dabei geht es um tatsächliche Einsparungen, soziale Folgen und die Versorgungssicherheit.');
