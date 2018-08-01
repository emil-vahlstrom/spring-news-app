/******************** DDL ********************/  

drop database if exists `news_db`;
CREATE SCHEMA `news_db`;
use `news_db`;

/*All User's gets stored in APP_USER table*/
create table APP_USER (
   id BIGINT NOT NULL AUTO_INCREMENT,
   sso_id VARCHAR(30) NOT NULL,
   password VARCHAR(100) NOT NULL,
   first_name VARCHAR(30) NOT NULL,
   last_name  VARCHAR(30) NOT NULL,
   state VARCHAR(30),
   email VARCHAR(30) NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (sso_id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
   
/* USER_PROFILE table contains all possible roles */ 
create table USER_PROFILE(
   id BIGINT NOT NULL AUTO_INCREMENT,
   type VARCHAR(30) NOT NULL,
   PRIMARY KEY (id),
   UNIQUE (type)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
   
/* JOIN TABLE for MANY-TO-MANY relationship*/  
CREATE TABLE APP_USER_USER_PROFILE (
    user_id BIGINT NOT NULL,
    user_profile_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, user_profile_id),
    CONSTRAINT FK_APP_USER FOREIGN KEY (user_id) REFERENCES APP_USER (id) ON DELETE CASCADE,
    CONSTRAINT FK_USER_PROFILE FOREIGN KEY (user_profile_id) REFERENCES USER_PROFILE (id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* USER_COMMENT */   
create table USER_COMMENT(
    id BIGINT NOT NULL AUTO_INCREMENT,
    reply_id BIGINT,
    -- user_id BIGINT NOT NULL,
    text VARCHAR(256) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active TINYINT(1) DEFAULT 1,
    PRIMARY KEY (id),
    -- CONSTRAINT FK_USER_COMMENT_APP_USER FOREIGN KEY (user_id) REFERENCES APP_USER(id) ON DELETE CASCADE,
    CONSTRAINT FK_USER_COMMENT_USER_COMMENT FOREIGN KEY (reply_id) REFERENCES USER_COMMENT(id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* APP_USER_USER_COMMENT */
create table APP_USER_USER_COMMENT(
    user_id BIGINT NOT NULL,
    comment_id BIGINT NOT NULL,
    PRIMARY KEY(user_id, comment_id),
    CONSTRAINT FK_APP_USER_USER_COMMENT_APP_USER FOREIGN KEY (user_id) REFERENCES APP_USER (id) ON DELETE CASCADE,
    CONSTRAINT FK_APP_USER_USER_COMMENT_USER_COMMENT FOREIGN KEY (comment_id) REFERENCES USER_COMMENT(id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* NEWS */
create table NEWS(
    id BIGINT NOT NULL AUTO_INCREMENT,
    headline VARCHAR(128) NOT NULL,
    lead VARCHAR(512) NOT NULL,
    body VARCHAR(8192) NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    active TINYINT(1) DEFAULT 1,
    PRIMARY KEY(id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* APP_USER_NEWS */
create table APP_USER_NEWS(
    user_id BIGINT NOT NULL,
    news_id BIGINT NOT NULL,
    PRIMARY KEY(user_id, news_id),
    CONSTRAINT FK_APP_USER_NEWS_APP_USER FOREIGN KEY (user_id) REFERENCES APP_USER (id) ON DELETE CASCADE,
    CONSTRAINT FK_APP_USER_NEWS_NEWS FOREIGN KEY (news_id) REFERENCES NEWS (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* USER_COMMENT_NEWS */
create table USER_COMMENT_NEWS(
    comment_id BIGINT NOT NULL,
    news_id BIGINT NOT NULL,
    PRIMARY KEY(comment_id, news_id),
    CONSTRAINT FK_USER_COMMENT_NEWS_USER_COMMENT FOREIGN KEY (comment_id) REFERENCES USER_COMMENT (id) ON DELETE CASCADE,
    CONSTRAINT FK_USER_COMMENT_NEWS_NEWS FOREIGN KEY (news_id) REFERENCES NEWS (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* IMAGE */
create table IMAGE(
    id BIGINT NOT NULL AUTO_INCREMENT,
    uri VARCHAR(64) NOT NULL,
    external TINYINT(1) DEFAULT 1,
    PRIMARY KEY(id),
    UNIQUE(uri)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE NEWS_IMAGE_HEAD(
	news_id BIGINT NOT NULL,
    image_id BIGINT NOT NULL,
    size TINYINT(2) DEFAULT 12,
    thumbnail TINYINT(1) DEFAULT 0,
    PRIMARY KEY(news_id, image_id),
    CONSTRAINT FK_NEWS_IMAGE_HEAD_NEWS FOREIGN KEY (news_id) REFERENCES NEWS (id) ON DELETE CASCADE,
    CONSTRAINT FK_NEWS_IMAGE_HEAD_IMAGE FOREIGN KEY (image_id) REFERENCES IMAGE (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IMAGE_SIZE(
	id BIGINT NOT NULL AUTO_INCREMENT,
    size VARCHAR(16),
    PRIMARY KEY(id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IMAGE_ALIGN(
	id BIGINT NOT NULL AUTO_INCREMENT,
    align VARCHAR(24),
    PRIMARY KEY(id)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE NEWS_IMAGE_BODY(
	news_id BIGINT NOT NULL,
    image_id BIGINT NOT NULL,
    size_id BIGINT NOT NULL,
    align_id BIGINT NOT NULL,
    PRIMARY KEY(news_id, image_id),
    CONSTRAINT FK_NEWS_IMAGE_BODY_NEWS FOREIGN KEY (news_id) REFERENCES NEWS (id) ON DELETE CASCADE,
    CONSTRAINT FK_NEWS_IMAGE_BODY_IMAGE FOREIGN KEY (image_id) REFERENCES IMAGE (id) ON DELETE CASCADE,
    CONSTRAINT FK_NEWS_IMAGE_BODY_IMAGE_SIZE FOREIGN KEY (size_id) REFERENCES IMAGE_SIZE (id) ON DELETE CASCADE,
    CONSTRAINT FK_NEWS_IMAGE_BODY_IMAGE_ALIGN FOREIGN KEY (align_id) REFERENCES IMAGE_ALIGN (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET=utf8;

/* Create persistent_logins Table used to store rememberme related stuff*/
CREATE TABLE persistent_logins (
    username VARCHAR(64) NOT NULL,
    series VARCHAR(64) NOT NULL,
    token VARCHAR(64) NOT NULL,
    last_used TIMESTAMP NOT NULL,
    PRIMARY KEY (series)
) ENGINE = InnoDB DEFAULT CHARSET=utf8;
  
/******************** DML ********************/ 
/* Populate USER_PROFILE Table */

/* POST AND DISABLES OWN COMMENTS, REPLIES TO OTHER'S COMMENTS */
INSERT INTO USER_PROFILE(type)
VALUES ('USER');
  
/* CREATES, DISABLES USERS, EDIT AND REMOVES NEWS */
INSERT INTO USER_PROFILE(type) 
VALUES ('ADMIN');

INSERT INTO USER_PROFILE(type)
VALUES ('DBA');

/* CREATES, EDITS AND DISABLES OWN NEWS */
INSERT INTO USER_PROFILE(type) 
VALUES ('PUBLISHER'); 
  
/* Populate one Admin User which will further create other users for the application using GUI */
INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)
VALUES ('sam','$2a$10$iNa/lhcPSxdhNXJg.lItL.tHQrXuOaP0Sh6OtwlaL9wsxZXdJ5f/K', 'Sam','Smith','samy@xyz.com');
  
INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)
VALUES('user1', '$2a$10$iNa/lhcPSxdhNXJg.lItL.tHQrXuOaP0Sh6OtwlaL9wsxZXdJ5f/K', 'Joe', 'Harboe', 'joe@harboebox.com');

INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)
VALUES('user2', '$2a$10$iNa/lhcPSxdhNXJg.lItL.tHQrXuOaP0Sh6OtwlaL9wsxZXdJ5f/K', 'Mike', 'Smith', 'mikesmith@hellodomain.co.uk');

INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)
VALUES('publisher1', '$2a$10$iNa/lhcPSxdhNXJg.lItL.tHQrXuOaP0Sh6OtwlaL9wsxZXdJ5f/K', 'Leonard', 'Jones', 'leowriter1312@hotmail.com');

INSERT INTO APP_USER(sso_id, password, first_name, last_name, email)
VALUES('publisher2', '$2a$10$iNa/lhcPSxdhNXJg.lItL.tHQrXuOaP0Sh6OtwlaL9wsxZXdJ5f/K', 'Menga', 'Rodonen', 'menga.rodonen@finland.nu');
  
/* Populate JOIN Table */
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
  SELECT user.id, profile.id FROM app_user user, user_profile profile
  where user.sso_id='sam' and profile.type='ADMIN';
-- INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
--   SELECT user.id, profile.id FROM app_user user, user_profile profile
--   where user.sso_id='sam' and profile.type='DBA';
-- INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
--   SELECT user.id, profile.id FROM app_user user, user_profile profile
--   where user.sso_id='sam' and profile.type='PUBLISHER';
  
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
VALUES(
	(SELECT user.id FROM APP_USER user WHERE user.sso_id='sam'),
    (SELECT profile.id FROM USER_PROFILE profile WHERE profile.type='DBA')
);

INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
	SELECT user.id, profile.id FROM APP_USER user, USER_PROFILE profile
    WHERE user.sso_id='sam' AND profile.type='PUBLISHER';
  
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
    SELECT user.id, profile.id FROM APP_USER user, USER_PROFILE profile
    WHERE user.sso_id='user1' AND profile.type='USER';
    
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
    SELECT user.id, profile.id FROM APP_USER user, USER_PROFILE profile
    WHERE user.sso_id='user2' AND profile.type='USER';
    
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
    SELECT user.id, profile.id FROM APP_USER user, USER_PROFILE profile
    WHERE user.sso_id='publisher1' AND profile.type='PUBLISHER';
    
INSERT INTO APP_USER_USER_PROFILE (user_id, user_profile_id)
	SELECT user.id, profile.id FROM APP_USER user, USER_PROFILE profile
    WHERE user.sso_id='publisher2' AND profile.type='PUBLISHER';

INSERT INTO user_comment(text) 
VALUES('This is a comment');

INSERT INTO user_comment(reply_id, text)
VALUES(
    (SELECT comment.id FROM USER_COMMENT comment WHERE comment.text = 'This is a comment' LIMIT 1), 
    'This is a reply');
    
INSERT INTO user_comment(text)
VALUES('Wow, who could have known?');

INSERT INTO user_comment(reply_id, text)
VALUES(
	(SELECT comment.id FROM USER_COMMENT comment WHERE comment.text = 'Wow, who could have known?' LIMIT 1), 
    'Yeah, this is some crazy stuff');
    
INSERT INTO user_comment(reply_id, text)
	SELECT comment.id, 'I certainly didn\'t!' FROM USER_COMMENT comment 
    WHERE comment.text = 'Wow, who could have known?';

INSERT INTO user_comment(reply_id, text)
VALUES(
	(SELECT comment.id FROM USER_COMMENT comment WHERE comment.text = 'Yeah, this is some crazy stuff' LIMIT 1),
    'I totally agree'
);

INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'user1' AND comment.text = 'This is a comment' LIMIT 1;

INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'user2' AND comment.text = 'This is a reply' LIMIT 1;
    
INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'user1' AND comment.text = 'Wow, who could have known?' LIMIT 1;
    
INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'user2' AND comment.text = 'Yeah, this is some crazy stuff' LIMIT 1;
    
INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'user1' AND comment.text = 'I totally agree' LIMIT 1;
    
INSERT INTO APP_USER_USER_COMMENT(user_id, comment_id)
    SELECT user.id, comment.id FROM APP_USER user, USER_COMMENT comment
    WHERE user.sso_id = 'publisher1' AND comment.text = 'I certainly didn\'t!' LIMIT 1;

INSERT INTO NEWS(headline, lead, body) VALUES('Ratata!', 'I love eating toasted cheese and tuna sandwiches.', '<p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KPMRVAREV0.jpg"><hr class="faded"><span>This is a caption.</span></div>Lorem ipsum dolor sit amet,consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. <b>Lorem ipsum dolor sit amet,consectetur adipiscing elit</b>. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Curabitur sodales ligula in libero. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/A4Y2Q66EL4.jpg"><hr class="faded"><span>This is a caption.</span></div>Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus,iaculis vel,suscipit quis,luctus non,massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. </p><p><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/6VOP7FYDYI.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg"><hr class="faded"><span>This is a caption.</span></div><i>Lorem ipsum dolor sit amet,consectetur adipiscing elit</i>. Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh. Quisque volutpat condimentum velit. <b>Sed dignissim lacinia nunc</b>. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. <b>Maecenas mattis</b>. Nam nec ante. Sed lacinia,urna non tincidunt mattis,tortor neque adipiscing diam,a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg"><hr class="faded"><span>This is a caption.</span></div>Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam. <div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KPMRVAREV0.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui. Praesent blandit dolor. <b>Etiam ultrices</b>. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. <i>Ut fringilla</i>. Donec lacus nunc,viverra nec,blandit vel,egestas et,augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. </p><p><i>Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh</i>. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis,venenatis tristique,dignissim in,ultrices sit amet,augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. <b>Curabitur sit amet mauris</b>. Vestibulum nisi lectus,commodo ac,facilisis ac,ultricies eu,pede. Ut orci risus,accumsan porttitor,cursus quis,aliquet eget,justo. </p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>');
INSERT INTO NEWS(headline, lead, body) VALUES('The old apple revels in its authority.', 'A song can make or ruin a person\'s day if they let it get to them.', '<p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg"><hr class="faded"><span>This is a caption.</span></div>Lorem ipsum dolor sit amet,consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. <div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. </p><p>Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. <i>Lorem ipsum dolor sit amet,consectetur adipiscing elit</i>. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus,iaculis vel,suscipit quis,luctus non,massa. <b>Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos</b>. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh. Quisque volutpat condimentum velit. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. <b>Maecenas mattis</b>. Nam nec ante. Sed lacinia,urna non tincidunt mattis,tortor neque adipiscing diam,a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. </p><p>Sed lectus. Integer euismod lacus luctus magna. <b>Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos</b>. Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. <i>Fusce ac turpis quis ligula lacinia aliquet</i>. Morbi in ipsum sit amet pede facilisis laoreet. <i>Ut fringilla</i>. Donec lacus nunc,viverra nec,blandit vel,egestas et,augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui</b>. Nulla facilisi. Integer lacinia sollicitudin massa. <i>Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam</i>. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. <b>Curabitur sit amet mauris</b>. Quisque nisl felis,venenatis tristique,dignissim in,ultrices sit amet,augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. <i>Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui</i>. Vestibulum nisi lectus,commodo ac,facilisis ac,ultricies eu,pede. Ut orci risus,accumsan porttitor,cursus quis,aliquet eget,justo. Sed pretium blandit orci. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('Joe made the sugar cookies; Susan decorated them.', 'I am happy to take your donation; any amount will be greatly appreciated.', '<p>Lorem ipsum dolor sit amet,consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg"><hr class="faded"><span>This is a caption.</span></div>Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Curabitur sodales ligula in libero. </p><p><b>Lorem ipsum dolor sit amet,consectetur adipiscing elit</b>. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. <i>Lorem ipsum dolor sit amet,consectetur adipiscing elit</i>. In scelerisque sem at dolor. <b>Mauris massa</b>. Maecenas mattis. Sed convallis tristique sem.<div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Vestibulum lacinia arcu eget nulla</b>. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus,iaculis vel,suscipit quis,luctus non,massa. <i>Lorem ipsum dolor sit amet,consectetur adipiscing elit</i>. Fusce ac turpis quis ligula lacinia aliquet. <i>Lorem ipsum dolor sit amet,consectetur adipiscing elit</i>. Mauris ipsum. Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. </p><p><b>Maecenas mattis</b>. Nam nec ante. Sed lacinia,urna non tincidunt mattis,tortor neque adipiscing diam,a cursus ipsum ante quis turpis. Nulla facilisi. <b>Proin ut ligula vel nunc egestas porttitor</b>. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. <i>Maecenas mattis</i>. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. <i>Fusce ac turpis quis ligula lacinia aliquet</i>. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc,viverra nec,blandit vel,egestas et,augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div>Cras metus. Sed aliquet risus a tortor. <b>Donec lacus nunc,viverra nec,blandit vel,egestas et,augue</b>. Integer id quam. Morbi mi. Quisque nisl felis,venenatis tristique,dignissim in,ultrices sit amet,augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. <b>Nulla facilisi</b>. Vestibulum nisi lectus,commodo ac,facilisis ac,ultricies eu,pede. Ut orci risus,accumsan porttitor,cursus quis,aliquet eget,justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('Rock music approaches at high velocity.', 'The sky is clear; the stars are twinkling. If I don\'t like something, I\'ll stay away from it.', '<p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg"><hr class="faded"><span>This is a caption.</span></div>Lorem ipsum dolor sit amet,consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. </p><p><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/LJB9IHYKU9.jpg"><hr class="faded"><span>This is a caption.</span></div>Curabitur tortor. Pellentesque nibh. <b>Fusce nec tellus sed augue semper porta</b>. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus,iaculis vel,suscipit quis,luctus non,massa. Fusce ac turpis quis ligula lacinia aliquet. <div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JZ1KFAEJ9B.jpg"><hr class="faded"><span>This is a caption.</span></div>Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. <b>Sed dignissim lacinia nunc</b>. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. </p><p><i>Curabitur tortor</i>. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. <i>Aenean quam</i>. Nunc feugiat mi a tellus consequat imperdiet. <b>Fusce ac turpis quis ligula lacinia aliquet</b>. <div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/HMQEHSTF6Z.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum sapien. Proin quam. <b>Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis</b>. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. </p><p>Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. <b>Sed non quam</b>. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/A6QMCBXYH2.jpg"><hr class="faded"><span>This is a caption.</span></div>Cras metus. Sed aliquet risus a tortor. <b>Donec lacus nunc, viverra nec, blandit vel, egestas et, augue</b>. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/DREWAGZJWT.jpg"><hr class="faded"><span>This is a caption.</span></div>Ut eu diam at pede suscipit sodales. <b>Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue</b>. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('This is a Japanese doll.', 'We have never been to Asia, nor have we visited Africa.', '<p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. <b>Sed cursus ante dapibus diam</b>. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div>Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. <b>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos</b>. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. <b>Mauris massa</b>. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div> Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. </p><p>Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. <i>Mauris massa</i>. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. <div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg"><hr class="faded"><span>This is a caption.</span></div>Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Suspendisse in justo eu magna luctus suscipit</b>. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. <i>Etiam ultrices</i>. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('The waves were crashing on the shore!', 'Check back tomorrow; I will see if the book has arrived. It was getting dark, and we weren\'t there yet.', '<p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. <b>Curabitur sit amet mauris</b>. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. <b>Curabitur sit amet mauris</b>. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg"><hr class="faded"><span>This is a caption.</span></div>Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. <b>Cras metus</b>. Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. </p><p><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/6VOP7FYDYI.jpg"><hr class="faded"><span>This is a caption.</span></div>Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. <b>Ut eu diam at pede suscipit sodales</b>. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. <i>Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue</i>. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. </p><p><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg"><hr class="faded"><span>This is a caption.</span></div>Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. <b>Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh</b>. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. <b>Ut fringilla</b>. Sed non quam. In vel mi sit amet augue congue elementum. <b>Suspendisse potenti</b>. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. <i>Nunc feugiat mi a tellus consequat imperdiet</i>. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. <b>Sed non quam</b>. Integer lacinia sollicitudin massa. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('I really want to go to work, but I am too sick to drive.', 'A purple pig and a green donkey flew a kite in the middle of the night and ended up sunburnt.', '<p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. <b>Cras metus</b>. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. </p><p><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div>Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. <i>Proin sodales libero eget ante</i>. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KPMRVAREV0.jpg"><hr class="faded"><span>This is a caption.</span></div>Fusce nec tellus sed augue semper porta. <i>Integer id quam</i>. Mauris massa. <b>Sed cursus ante dapibus diam</b>. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. <b>Integer nec odio</b>. Curabitur tortor. Pellentesque nibh. Aenean quam. <i>Integer nec odio</i>. In scelerisque sem at dolor. Maecenas mattis. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. <b>In scelerisque sem at dolor</b>. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg"><hr class="faded"><span>This is a caption.</span></div>Nunc feugiat mi a tellus consequat imperdiet. <b>Mauris ipsum</b>. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. <i>Nam nec ante</i>. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('Check back tomorrow', 'He told us a very exciting adventure story.', '<p><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. <i>Vestibulum sapien</i>. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Vestibulum tincidunt malesuada tellus</b>. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. <b>Sed aliquet risus a tortor</b>. <div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. <b>Proin sodales libero eget ante</b>. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. <i>Sed aliquet risus a tortor</i>. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. </p><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. <b>Nulla ut felis in purus aliquam imperdiet</b>. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum lacinia arcu eget nulla. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. <i>Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula</i>. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. <b>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos</b>. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div> Maecenas mattis. Sed convallis tristique sem. <b>Curabitur sodales ligula in libero</b>. Proin ut ligula vel nunc egestas porttitor. <b>Vestibulum lacinia arcu eget nulla</b>. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. </p><p>Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. <i>Maecenas mattis</i>. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('The quick brown fox jumps over the lazy dog.', 'She wrote him a long letter, but he didn\'t read it.', '<p>Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. <b>Ut fringilla</b>. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. <i>Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh</i>. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. <b>Suspendisse in justo eu magna luctus suscipit</b>. Curabitur sit amet mauris. <i>Suspendisse in justo eu magna luctus suscipit</i>. Morbi in dui quis est pulvinar ullamcorper. </p><p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. <b>Curabitur sit amet mauris</b>. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. <i>Suspendisse in justo eu magna luctus suscipit</i>. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. <b>Morbi in dui quis est pulvinar ullamcorper</b>. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Integer id quam</b>. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. </p><p><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Sed pretium blandit orci</b>. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. <b>Duis sagittis ipsum</b>. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Maecenas mattis. <b>Curabitur sodales ligula in libero</b>. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. </p>');
INSERT INTO NEWS(headline, lead, body) VALUES('She borrowed the book from him many years ago and hasn\'t yet returned it.', 'She did not cheat on the test, for it was not the right thing to do.', '<p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg"><hr class="faded"><span>This is a caption.</span></div><i>Curabitur sodales ligula in libero</i>. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. <i>Pellentesque nibh</i>. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. <div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg"><hr class="faded"><span>This is a caption.</span></div> <b>Suspendisse potenti</b>. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. </p><p><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/DREWAGZJWT.jpg"><hr class="faded"><span>This is a caption.</span></div>In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. <i>Nulla facilisi</i>. <div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg"><hr class="faded"><span>This is a caption.</span></div>Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. </p><p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>Integer id quam. Morbi mi. Quisque nisl felis, venenatis tristique, dignissim in, ultrices sit amet, augue. Proin sodales libero eget ante. <b>Donec lacus nunc, viverra nec, blandit vel, egestas et, augue</b>. Nulla quam. Aenean laoreet. Vestibulum nisi lectus, commodo ac, facilisis ac, ultricies eu, pede. <b>Integer id quam</b>. <div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/6VOP7FYDYI.jpg"><hr class="faded"><span>This is a caption.</span></div>Ut orci risus, accumsan porttitor, cursus quis, aliquet eget, justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit, fermentum non, convallis id, sagittis at, neque. Nullam mauris orci, aliquet et, iaculis et, viverra vitae, ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg"><hr class="faded"><span>This is a caption.</span></div>Vivamus consectetuer risus et tortor. <i>Vestibulum tincidunt malesuada tellus</i>. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. <b>Nulla quam</b>. Praesent libero. Sed cursus ante dapibus diam. <i>Integer lacinia sollicitudin massa</i>. Sed nisi. Nulla quis sem at nibh elementum imperdiet. <b>Vivamus consectetuer risus et tortor</b>. Duis sagittis ipsum. Praesent mauris. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Fusce nec tellus sed augue semper porta. Mauris massa. </p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/HMQEHSTF6Z.jpg"><hr class="faded"><span>This is a caption.</span></div>');
INSERT INTO NEWS(headline, lead, body) VALUES('Buzzcocks attacks humans, who will prevail?', 'The mighty <strong>buzzcocks</strong>, whatever that is, has attacked the humans of the city of Villainville. People flee in terror, some take up arms to fight the attackers.', '<p>Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. <b>Vestibulum lacinia arcu eget nulla</b>. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. </p><p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg"><hr class="faded"><span>This is a caption.</span></div>Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. <b>Proin ut ligula vel nunc egestas porttitor</b>. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. </p><p><div class="xlarge center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JZ1KFAEJ9B.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum sapien. <i>Maecenas mattis</i>. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc,viverra nec,blandit vel,egestas et,augue. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. <b>Curabitur sit amet mauris</b>. Morbi mi. Quisque nisl felis,venenatis tristique,dignissim in,ultrices sit amet,augue. </p><p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div>Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus,commodo ac,facilisis ac,ultricies eu,pede. Ut orci risus,accumsan porttitor,cursus quis,aliquet eget,justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit,fermentum non,convallis id,sagittis at,neque. Nullam mauris orci,aliquet et,iaculis et,viverra vitae,ligula. <i>Vestibulum tincidunt malesuada tellus</i>. Nulla ut felis in purus aliquam imperdiet. <i>Integer id quam</i>. Maecenas aliquet mollis lectus. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Vivamus consectetuer risus et tortor. <i>Curabitur sit amet mauris</i>. Lorem ipsum dolor sit amet,consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. </p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/DREWAGZJWT.jpg"><hr class="faded"><span>This is a caption.</span></div>');
INSERT INTO NEWS(headline, lead, body) VALUES('Crazy doctor make zombies rise!', 'Doctor Suspicious of Notre Dame has <em>successfully</em> raised undead to work for him in his kitchen, apparently they are good cooks.', '<p><div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg"><hr class="faded"><span>This is a caption.</span></div>Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus,iaculis vel,suscipit quis,luctus non,massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh. </p><p><div class="small right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/LJB9IHYKU9.jpg"><hr class="faded"><span>This is a caption.</span></div>Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra,per inceptos himenaeos. Nam nec ante. Sed lacinia,urna non tincidunt mattis,tortor neque adipiscing diam,a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. <b>Mauris ipsum</b>. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg"><hr class="faded"><span>This is a caption.</span></div><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg"><hr class="faded"><span>This is a caption.</span></div><b>Nulla metus metus,ullamcorper vel,tincidunt sed,euismod in,nibh</b>. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;Morbi lacinia molestie dui. <div class="medium right-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg"><hr class="faded"><span>This is a caption.</span></div>Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc,viverra nec,blandit vel,egestas et,augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. </p><p><div class="small left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg"><hr class="faded"><span>This is a caption.</span></div>Curabitur sit amet mauris. Morbi in dui quis est pulvinar ullamcorper. <i>Sed lectus</i>. Nulla facilisi. Integer lacinia sollicitudin massa. Cras metus. Sed aliquet risus a tortor. Integer id quam. Morbi mi. Quisque nisl felis,venenatis tristique,dignissim in,ultrices sit amet,augue. <i>Quisque cursus,metus vitae pharetra auctor,sem massa mattis sem,at interdum magna augue eget diam</i>. Proin sodales libero eget ante. Nulla quam. Aenean laoreet. Vestibulum nisi lectus,commodo ac,facilisis ac,ultricies eu,pede. </p><p><div class="medium left-inline"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg"><hr class="faded"><span>This is a caption.</span></div><i>Donec lacus nunc,viverra nec,blandit vel,egestas et,augue</i>. Ut orci risus,accumsan porttitor,cursus quis,aliquet eget,justo. Sed pretium blandit orci. Ut eu diam at pede suscipit sodales. Aenean lectus elit,fermentum non,convallis id,sagittis at,neque. Nullam mauris orci,aliquet et,iaculis et,viverra vitae,ligula. Nulla ut felis in purus aliquam imperdiet. Maecenas aliquet mollis lectus. Vivamus consectetuer risus et tortor. <b>Proin sodales libero eget ante</b>. Lorem ipsum dolor sit amet,consectetur adipiscing elit. <b>Ut eu diam at pede suscipit sodales</b>. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. </p><div class="large center-block"><img class="small-shadow" src="https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg"><hr class="faded"><span>This is a caption.</span></div>');

#PUBLISHER
INSERT INTO APP_USER_NEWS(user_id, news_id) 
VALUES(
    (SELECT user.id FROM APP_USER user WHERE user.sso_id = 'publisher1'),
    (SELECT NEWS.id FROM NEWS WHERE NEWS.headline LIKE 'Buzzcocks attacks%' LIMIT 1)
);

INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news 
    WHERE user.sso_id = 'publisher2' AND news.headline LIKE 'Crazy doctor%';
    
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news 
    WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'Ratata%';

INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'The old apple revels%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher2' AND news.headline LIKE 'Joe made the%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'Rock music approaches%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher2' AND news.headline LIKE 'This is a Japanese%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'The waves were crashing%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher2' AND news.headline LIKE 'I really want to go to work%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'Check back tomorrow%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher2' AND news.headline LIKE 'The quick brown fox%';
INSERT INTO APP_USER_NEWS(user_id, news_id) 
    SELECT user.id, news.id FROM APP_USER user, NEWS news WHERE user.sso_id = 'publisher1' AND news.headline LIKE 'She borrowed the book%';
    
#USER_COMMENT_NEWS
INSERT INTO USER_COMMENT_NEWS(comment_id, news_id)
	SELECT comment.id, news.id FROM USER_COMMENT comment, NEWS news
WHERE comment.text = 'This is a comment' AND news.headline LIKE 'Buzzcocks attacks humans%' LIMIT 1;
    
INSERT INTO USER_COMMENT_NEWS(comment_id, news_id)
	SELECT comment.id, news.id FROM USER_COMMENT comment, NEWS
    WHERE comment.text = 'Wow, who could have known?' AND news.headline LIKE 'Crazy doctor make zombies rise%' LIMIT 1;
   
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/A4Y2Q66EL4.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/6VOP7FYDYI.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/KPMRVAREV0.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/DREWAGZJWT.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/A6QMCBXYH2.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/HMQEHSTF6Z.jpg');
INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/JZ1KFAEJ9B.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/LJB9IHYKU9.jpg');

INSERT INTO IMAGE(uri) VALUES('https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg');

INSERT INTO IMAGE_SIZE(size) VALUES('SMALL');
INSERT INTO IMAGE_SIZE(size) VALUES('MEDIUM');
INSERT INTO IMAGE_SIZE(size) VALUES('LARGE');

INSERT INTO IMAGE_ALIGN(align) VALUES('LEFT-INLINE-FLOAT');
INSERT INTO IMAGE_ALIGN(align) VALUES('RIGHT-INLINE-FLOAT');
INSERT INTO IMAGE_ALIGN(align) VALUES('CENTER-BLOCK');

INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 3, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Crazy doctor make zombies rise!' AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/A4Y2Q66EL4.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 3, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Crazy doctor make zombies rise!' AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/6VOP7FYDYI.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 3, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Crazy doctor make zombies rise!' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/8V46UZCS0V.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 3, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Crazy doctor make zombies rise!' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/KPMRVAREV0.jpg';
    
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Buzzcocks attacks humans, who will prevail?' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/EP88PX3IST.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Buzzcocks attacks humans, who will prevail?' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/64QH4OUMET.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, -1, 1 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Buzzcocks attacks humans, who will prevail?' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/JWWHZLJVH6.jpg';
    
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 12, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'She borrowed the book from him many years ago and hasn\'t yet returned it.' 
		AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/YM863UXAFR.jpg';
        
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Check back tomorrow' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/SKROKKQB5V.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Check back tomorrow' AND IMAGE.uri LIKE 'https://cdn.stocksnap.io/img-thumbs/960w/XAC1HYZSBK.jpg';

INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 4, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'The waves were crashing on the shore!' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/QYDRWBCRJJ.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 4, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'The waves were crashing on the shore!' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/DREWAGZJWT.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 4, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'The waves were crashing on the shore!' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/A6QMCBXYH2.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, -1, 1 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'The waves were crashing on the shore!' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/CWUWIMTIDO.jpg';

INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'This is a Japanese doll.' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/HMQEHSTF6Z.jpg';
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 6, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'This is a Japanese doll.' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/JZ1KFAEJ9B.jpg';

INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 12, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Joe made the sugar cookies; Susan decorated them.' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/LJB9IHYKU9.jpg';
    
INSERT INTO NEWS_IMAGE_HEAD(news_id, image_id, size, thumbnail) SELECT news.id, image.id, 12, 0 FROM NEWS, IMAGE
    WHERE NEWS.headline = 'Ratata!' 
    AND IMAGE.uri = 'https://cdn.stocksnap.io/img-thumbs/960w/KGGCZ5CC9Z.jpg';

-- CONTENT BELOW IF FORWARD ENGINEERED FROM AN EXISTING DB

SET FOREIGN_KEY_CHECKS=0;

INSERT INTO `app_user` VALUES (15,'user3','$2a$10$gsiLcj7Gl7H/tKP11Wa7oe4hjetKd52ccVe0OqodXs42O4RZyp67O','Nicholas','Freeman',NULL,'user-the-third@spam-mail.nu');
INSERT INTO `app_user_user_comment` VALUES (3,7),(3,8),(3,9),(3,10),(3,11),(3,12),(3,13),(3,14),(3,15),(3,16),(3,17),(3,18),(3,19),(3,20),(3,21),(3,22),(3,23),(3,24),(3,25),(3,26),(3,27),(3,28),(3,29),(3,30),(3,31),(3,32),(3,33),(2,34),(3,36),(3,37),(3,38),(3,39),(3,40),(3,41),(3,42),(3,43),(3,44),(3,45),(3,46),(3,47),(3,48),(3,49),(3,50),(3,51),(3,52),(3,53),(3,54),(3,55),(3,56),(3,57),(3,58),(3,59),(3,60),(3,61),(3,62),(3,63),(3,64),(3,65),(3,66),(3,67),(3,68),(3,69),(3,70),(3,71),(2,72),(2,73),(2,74),(2,75),(2,76),(2,77),(2,78),(2,79),(3,80),(3,81),(3,82),(3,83),(3,84),(3,85),(3,86),(3,87),(3,88),(3,89),(3,90),(3,91),(3,92),(3,93),(3,94),(3,95),(3,96),(3,97),(3,98),(3,99),(3,100),(3,101),(3,102),(3,103),(3,104),(3,105),(3,106),(3,107),(3,108),(3,109),(3,110),(3,111),(3,112),(3,113),(3,114),(3,115),(3,116),(2,117),(2,118),(2,119),(2,120),(2,121),(2,122),(2,123),(2,124),(2,125),(15,126),(15,127);
INSERT INTO `app_user_user_profile` VALUES (15,1);
INSERT INTO `user_comment` VALUES (7,NULL,'This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. ','2018-02-25 14:18:18','2018-02-25 14:18:18',1),(8,7,'Ok','2018-02-25 14:18:49','2018-02-25 14:18:49',1),(9,7,'a','2018-02-25 22:28:00','2018-02-25 22:28:00',1),(10,9,'a','2018-02-25 22:28:12','2018-02-25 22:28:12',1),(11,10,'a','2018-02-25 22:28:18','2018-02-25 22:28:18',1),(12,11,'a','2018-02-25 22:33:09','2018-02-25 22:33:09',1),(13,12,'a','2018-02-25 22:33:14','2018-02-25 22:33:14',1),(14,13,'a','2018-02-25 22:33:18','2018-02-25 22:33:18',1),(15,14,'a','2018-02-25 22:33:23','2018-02-25 22:33:23',0),(16,15,'a','2018-02-25 22:33:29','2018-02-25 22:33:29',1),(17,16,'a','2018-02-25 22:33:34','2018-02-25 22:33:34',1),(18,17,'a','2018-02-25 22:33:42','2018-02-25 22:33:42',1),(19,18,'sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf sdasdasfadfasdf ','2018-02-25 22:50:08','2018-02-25 22:50:08',1),(20,19,'sa','2018-02-25 22:50:15','2018-02-25 22:50:15',1),(21,3,'hej','2018-02-26 20:47:19','2018-02-26 20:47:19',1),(22,7,'hej hej','2018-02-26 20:47:47','2018-02-26 20:47:47',1),(23,6,'Ok fine!','2018-02-26 21:37:04','2018-02-26 21:37:04',1),(24,23,'Very fine!','2018-02-26 21:37:13','2018-02-26 21:37:13',1),(25,11,'hej hej hej','2018-02-26 21:47:51','2018-02-26 21:47:51',1),(26,25,'hej hej hej','2018-02-26 21:47:59','2018-02-26 21:47:59',1),(27,9,'hej hej hej','2018-02-26 21:48:24','2018-02-26 21:48:24',1),(28,27,'hej hej hej','2018-02-26 21:48:34','2018-02-26 21:48:34',1),(29,27,'hej hej hej!!!!!!!!','2018-02-26 21:48:44','2018-02-26 21:48:44',1),(30,28,'ja hej hej1!','2018-02-26 21:48:54','2018-02-26 21:48:54',1),(31,29,'hoj hoj hoj!','2018-02-26 21:49:04','2018-02-26 21:49:04',1),(32,29,'hej huj!','2018-02-26 21:49:24','2018-02-26 21:49:24',1),(33,31,'hij hij!','2018-02-26 21:49:37','2018-02-26 21:49:37',1),(34,NULL,'This is a new comment to post!','2018-02-27 21:20:50','2018-02-27 21:20:50',1),(36,NULL,'comment1','2018-03-04 22:44:20','2018-03-04 22:44:20',1),(37,NULL,'comment2','2018-03-04 22:44:26','2018-03-04 22:44:26',1),(38,NULL,'comment3','2018-03-04 22:44:35','2018-03-04 22:44:35',1),(39,NULL,'comment4','2018-03-04 22:44:42','2018-03-04 22:44:49',1),(40,NULL,'comment5','2018-03-04 23:04:28','2018-03-04 23:04:28',1),(41,NULL,'comment6','2018-03-04 23:04:40','2018-03-04 23:04:40',1),(42,NULL,'comment7','2018-03-04 23:05:00','2018-03-04 23:05:00',1),(43,NULL,'comment8','2018-03-04 23:05:15','2018-03-04 23:05:15',1),(44,NULL,'comment9','2018-03-04 23:06:18','2018-03-04 23:06:18',1),(45,NULL,'comment10','2018-03-04 23:06:23','2018-03-04 23:06:23',1),(46,NULL,'comment11','2018-03-04 23:06:31','2018-03-04 23:06:31',1),(47,NULL,'comment12','2018-03-04 23:07:06','2018-03-04 23:07:06',1),(48,NULL,'comment13','2018-03-04 23:07:12','2018-03-04 23:07:12',1),(49,NULL,'comment14','2018-03-04 23:07:19','2018-03-04 23:07:19',1),(50,NULL,'comment15','2018-03-04 23:07:25','2018-03-04 23:07:25',1),(51,50,'reply1','2018-03-06 20:01:46','2018-03-06 20:01:46',1),(52,50,'reply2','2018-03-06 20:01:54','2018-03-06 20:01:54',1),(53,50,'reply3','2018-03-06 20:02:02','2018-03-06 20:02:02',1),(54,50,'reply4','2018-03-06 20:02:09','2018-03-06 20:02:09',1),(55,50,'reply5','2018-03-06 20:02:16','2018-03-06 20:02:16',1),(56,50,'reply6','2018-03-06 20:02:22','2018-03-06 20:02:22',1),(57,50,'reply7','2018-03-06 20:02:28','2018-03-06 20:02:28',1),(58,57,'comment1','2018-03-06 20:28:45','2018-03-06 20:28:45',1),(59,57,'comment2','2018-03-06 20:29:10','2018-03-06 20:29:10',1),(60,57,'comment3','2018-03-06 20:29:19','2018-03-06 20:29:19',1),(61,57,'comment4','2018-03-06 20:29:47','2018-03-06 20:29:47',1),(62,57,'comment5','2018-03-06 20:29:55','2018-03-06 20:29:55',1),(63,57,'comment6','2018-03-06 20:30:01','2018-03-06 20:30:01',1),(64,63,'comment1','2018-03-06 20:30:33','2018-03-06 20:30:33',1),(65,64,'comment1','2018-03-06 20:30:39','2018-03-06 20:30:39',1),(66,63,'comment2','2018-03-06 20:30:48','2018-03-06 20:30:48',1),(67,63,'comment3','2018-03-06 20:30:57','2018-03-06 20:30:57',1),(68,63,'comment4','2018-03-06 20:31:02','2018-03-06 20:31:02',1),(69,63,'comment5','2018-03-06 20:31:09','2018-03-06 20:31:09',1),(70,63,'comment6','2018-03-06 20:31:24','2018-03-06 20:31:24',1),(71,66,'comment1','2018-03-06 20:31:31','2018-03-06 20:31:31',1),(72,NULL,'comment1','2018-03-07 13:18:12','2018-03-07 13:18:12',1),(73,72,'comment2','2018-03-07 13:18:24','2018-03-07 13:18:24',1),(74,73,'comment3','2018-03-07 13:18:32','2018-03-07 13:18:32',1),(75,72,'comment4','2018-03-07 13:18:39','2018-03-07 13:18:39',1),(76,NULL,'comment5','2018-03-07 13:18:50','2018-03-07 13:18:50',1),(77,NULL,'comment6','2018-03-07 13:19:37','2018-03-07 13:19:37',1),(78,NULL,'comment7','2018-03-07 13:19:54','2018-03-07 13:19:54',1),(79,NULL,'comment8','2018-03-07 13:20:07','2018-03-07 13:20:07',1),(80,9,'comment1','2018-03-07 23:28:18','2018-03-07 23:28:18',1),(81,9,'comment2','2018-03-07 23:29:09','2018-03-07 23:29:09',1),(82,9,'comment3','2018-03-07 23:29:25','2018-03-07 23:29:25',1),(83,9,'comment4','2018-03-07 23:29:58','2018-03-07 23:29:58',1),(84,NULL,'comment1','2018-03-07 23:33:40','2018-03-07 23:33:40',1),(85,NULL,'comment2','2018-03-07 23:33:48','2018-03-07 23:33:48',1),(86,NULL,'comment3','2018-03-07 23:33:53','2018-03-07 23:33:53',1),(87,NULL,'comment4','2018-03-07 23:33:58','2018-03-07 23:33:58',1),(88,NULL,'comment5','2018-03-07 23:34:03','2018-03-07 23:34:03',1),(89,NULL,'comment6','2018-03-07 23:34:09','2018-03-07 23:34:09',1),(90,89,'comment7','2018-03-07 23:34:22','2018-03-07 23:34:22',1),(91,89,'comment8','2018-03-07 23:34:33','2018-03-07 23:34:33',1),(92,89,'comment8','2018-03-07 23:38:10','2018-03-07 23:38:10',1),(93,89,'comment9','2018-03-07 23:39:20','2018-03-07 23:39:20',1),(94,89,'comment10','2018-03-07 23:39:26','2018-03-07 23:39:26',1),(95,89,'comment11','2018-03-07 23:39:44','2018-03-07 23:39:44',1),(96,88,'comment1','2018-03-07 23:40:22','2018-03-07 23:40:22',1),(97,88,'comment2','2018-03-07 23:40:27','2018-03-07 23:40:27',1),(98,88,'comment3','2018-03-07 23:40:32','2018-03-07 23:40:32',1),(99,88,'comment4','2018-03-07 23:40:36','2018-03-07 23:40:36',1),(100,88,'comment5','2018-03-07 23:40:49','2018-03-07 23:40:49',1),(101,100,'comment1','2018-03-07 23:46:11','2018-03-07 23:46:11',1),(102,99,'comment2','2018-03-07 23:46:28','2018-03-07 23:46:28',1),(103,36,'hej','2018-03-07 23:49:06','2018-03-07 23:49:06',1),(104,NULL,'comment1','2018-03-08 00:12:10','2018-03-08 00:12:10',1),(105,NULL,'comment2','2018-03-08 00:12:15','2018-03-08 00:12:15',1),(106,104,'comment3','2018-03-08 00:12:26','2018-03-08 00:12:26',1),(107,104,'comment4','2018-03-08 00:12:32','2018-03-08 00:12:32',1),(108,104,'comment5','2018-03-08 00:12:43','2018-03-08 00:12:43',1),(109,104,'comment6','2018-03-08 00:12:54','2018-03-08 00:12:54',1),(110,NULL,'comment7','2018-03-08 00:14:02','2018-03-08 00:15:07',1),(111,NULL,'comment8','2018-03-08 00:14:19','2018-03-08 00:15:13',1),(112,NULL,'comment9','2018-03-08 00:14:29','2018-03-08 00:15:20',1),(113,NULL,'comment10','2018-03-08 00:15:28','2018-03-08 00:15:28',1),(114,105,'comment12','2018-03-08 00:15:44','2018-03-08 00:15:44',1),(115,104,'comment777','2018-03-08 00:34:02','2018-03-08 00:34:20',1),(116,NULL,'comment1','2018-03-08 00:37:43','2018-03-08 00:37:43',1),(117,NULL,'comment1: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long!','2018-03-08 09:42:48','2018-03-10 19:58:13',1),(118,117,'reply1: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long.','2018-03-08 09:43:09','2018-03-08 10:13:47',1),(119,118,'reply2: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long.','2018-03-08 09:43:15','2018-03-08 10:13:38',1),(120,119,'reply3: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long.','2018-03-08 09:43:21','2018-03-08 10:13:12',1),(121,120,'reply4','2018-03-08 09:43:26','2018-03-08 09:43:26',1),(122,121,'reply5','2018-03-08 09:43:32','2018-03-08 09:43:32',1),(123,119,'reply5: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long.','2018-03-08 09:43:59','2018-03-08 10:13:29',1),(124,123,'reply6!','2018-03-08 09:44:39','2018-03-10 19:58:27',1),(125,50,'hej','2018-03-10 19:57:22','2018-03-10 19:57:22',1),(126,NULL,'Writing some random comment here.','2018-03-11 01:26:56','2018-03-11 01:26:56',1),(127,NULL,'comment2: This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long. This is a test comment that\'s supposed to very long!\r\n','2018-03-12 00:45:40','2018-03-12 00:45:40',1);
INSERT INTO `user_comment_news` VALUES (117,5),(127,5),(116,7),(104,8),(105,8),(110,8),(111,8),(112,8),(113,8),(84,9),(85,9),(86,9),(87,9),(88,9),(89,9),(72,10),(76,10),(77,10),(78,10),(79,10),(7,12),(34,12),(36,12),(37,12),(38,12),(39,12),(40,12),(41,12),(42,12),(43,12),(44,12),(45,12),(46,12),(47,12),(48,12),(49,12),(50,12),(126,12);

SET FOREIGN_KEY_CHECKS=1;