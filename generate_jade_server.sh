
    express --css sass $1
    cd $1
    npm install gulp run-sequence react react-dom browserify babelify vinyl-source-stream babel-core babel-preset-es2015 babel-preset-react babel-register gulp-eslint gulp-istanbul gulp-mocha gulp-task-loader isparta --save
    mkdir gulp-tasks
    echo 'var gulp = require("gulp");
    var browserify = require("browserify");
    var babelify = require("babelify");
    var source = require("vinyl-source-stream");

    module.exports = function () {
    console.log("broswer");
    return browserify("./public/javascripts/app.js")
    .transform(babelify, {presets: ["es2015", "react"]})
    .bundle()
    .pipe(source("javascripts/main.js"))
    .pipe(gulp.dest("./public/"));
    };
    ' > gulp-tasks/browserify.js
    echo 'var gulp = require("gulp"),
    eslint = require("gulp-eslint");

    module.exports = function () {
    return gulp.src(["**/*.js",
            "!node_modules/**/*.js",
            "!coverage/**/*.js"
        ])
        .pipe(eslint())
        .pipe(eslint.format())
        .pipe(eslint.failAfterError());
    };
    ' > gulp-tasks/eslint.js

    echo 'var babel    = require("babel-register"),
    gulp     = require("gulp"),
    isparta  = require("isparta"),
    istanbul = require("gulp-istanbul"),
    mocha    = require("gulp-mocha");

    module.exports = function (done) {
    gulp.src([

    ])
    .pipe(istanbul({
        instrumenter: isparta.Instrumenter,
        includeUntested: true
    }))
    .pipe(istanbul.hookRequire())
    .on("finish", function () {
        gulp.src(["test/**/*.js"])
            .pipe(mocha({
                compilers: {
                    js: babel
                },
                reporter: "spec",
                bail: true,
                timeout: 30000
            }))
            .pipe(istanbul.writeReports())
            // Enforce a coverage of 100%
            .pipe(istanbul.enforceThresholds({
                thresholds: {global: 100}
            }))
            .on("end", done);
    });
    };' > gulp-tasks/mocha-unit.js

    echo 'var gulp = require("gulp"),
    gulpTasks   = require("gulp-task-loader"),
    runSequence;

    /* eslint-enable no-unused-vars */
    gulpTasks("./gulp-tasks");
    runSequence = require("run-sequence");
    gulp.task("test", ["eslint", "mocha-unit"]);
    gulp.task("browser", ["browserify"]);
    ' > gulpfile.js

    mkdir public/javascripts/components
    echo 'var React = require("react");
    var ReactDOM = require("react-dom");

    var MessageList = React.createClass({
            render:function(){
                return (
                    <div>
                        hello world
                    </div>
                )
            }
        });

    module.exports =  MessageList;
    ' > public/javascripts/components/helloWorld.jsx

    echo 'var React = require("react");
    var ReactDOM = require("react-dom");


    var LikeButton = React.createClass({
    getInitialState: function() {
    return {liked: false};
    },
    handleClick: function(event) {
    this.setState({liked: !this.state.liked});
    },
    render: function() {
    var text = this.state.liked ? "like" : "havent liked";
    return (
      <p onClick={this.handleClick}>
        You {text} this. Click to toggle.
      </p>
    );
    }
    });
    module.exports =  LikeButton;' > public/javascripts/components/button.jsx

    echo 'var React       = require("react");
    var ReactDOM    = require("react-dom");
    var MessageList = React.createFactory(require("./components/helloWorld.jsx"));
    var LikeButton  = React.createFactory(require("./components/button.jsx"));
    var div         = document.getElementById("one");
    var button      = document.getElementById("example");

    console.log(div);
    console.log(MessageList);
    ReactDOM.render(new MessageList(), div);
    ReactDOM.render(new LikeButton(), button);
    ' > public/javascripts/app.js

    echo 'require("babel-core/register")({
    presets: ["es2015", "react"]
    });
    var React = require("react");
    var reactDOMServer = require("react-dom/server");

    var express = require("express");
    var router = express.Router();

    var MessageList = React.createFactory(require("../public/javascripts/components/helloWorld.jsx"));
    var LikeButton  = React.createFactory(require("../public/javascripts/components/button.jsx"));

    var htmlReact = reactDOMServer.renderToString(new MessageList());
    var likeButton = reactDOMServer.renderToString(new LikeButton());

    /* GET home page. */
    router.get("/", function(req, res, next) {
    res.render("index", { title: "Express", htmlReact: htmlReact, likeButton: likeButton });
    });

    module.exports = router;
    ' > routes/index.js

    echo 'extends layout
block content
  h1= title
  p Welcome to #{title}
  #one!=htmlReact
  #example!=likeButton' > views/index.jade


