# React Jade Generator Script

*Disclaimer: VERY VERY experimental just trying stuff out and having fun*
<br>
## To get started:
=======

### First
You'll need to have __node npm__ and __node-express-generator__ installed. <br>
Node: https://nodejs.org/en/ <br>
Express-Generator: `npm  install express-genorator -g` *(node must be installed first)*

### To run script 
* `. generate_jade_sever.sh <app name>` or on windows `bash generate_jade_sever.sh <app name>`

#### To set up the server side code
* After it completes run `npm install` *(`npm start` to test, only server side code. Toggle won't work)*

#### To integrate client side code
* Erase main.js *(can be found under public/Javascripts/main.js)*
* Then, run `gulp browser`
* Inside the views/layout.jade file add the main.js file as a script using jade syntax
* run `gulp browser` again


**Run `gulp browser` after any changes are made**