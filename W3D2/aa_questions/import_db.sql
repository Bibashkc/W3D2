PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
id INTEGER PRIMARY KEY,
fname TEXT NOT NULL,
lname TEXT NOT NULL
);


DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
body TEXT NOT NULL,
author_id INTEGER NOT NULL,

FOREIGN KEY (author_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
id INTEGER PRIMARY KEY,
author_id INTEGER NOT NULL,
question_id INTEGER NOT NULL,

FOREIGN KEY (author_id) REFERENCES users(id)
FOREIGN KEY (question_id) REFERENCES questions(id)
);


DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
id INTEGER PRIMARY KEY,
body TEXT NOT NULL,
author_id INTEGER NOT NULL,
question_id INTEGER NOT NULL,
parent_id INTEGER,

FOREIGN KEY (author_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (parent_id) REFERENCES replies(id)
);


DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
id INTEGER PRIMARY KEY,
user_id INTEGER NOT NULL,
question_id INTEGER NOT NULL,

FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (user_id) REFERENCES users(id)
);



INSERT INTO 
users (fname,lname)
VALUES
('bibash','kc'),
('oliver', 'smith');


INSERT INTO
questions (title, body, author_id)
VALUES 
('name','What is your name?', (SELECT id FROM users WHERE fname = 'bibash')),
('color','What is your favorite color?', (SELECT id FROM users WHERE fname = 'oliver'));


INSERT INTO
replies (body, author_id, question_id, parent_id)
VALUES
('oliver', (SELECT id FROM users WHERE fname = 'oliver'), (SELECT id FROM questions WHERE title = 'name'),NULL),
('bibash', (SELECT id FROM users WHERE fname = 'bibash'),( SELECT id FROM questions WHERE title = 'name'), (SELECT id FROM replies WHERE body = 'oliver')),
('blue', (SELECT id FROM users WHERE fname = 'bibash'), (SELECT id FROM questions WHERE title = 'color'),NULL);


INSERT INTO
question_likes (user_id, question_id)
VALUES
((SELECT id FROM users WHERE fname = 'oliver'),( SELECT id FROM questions WHERE title = 'name')),
((SELECT id FROM users WHERE fname = 'bibash'), (SELECT id FROM questions WHERE title = 'color'));