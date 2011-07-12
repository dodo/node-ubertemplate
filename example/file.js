var UberTemplate = require('../ubertemplate'),
    filepath = __dirname + "/views/coffeekup.coffee";

template = new UberTemplate();
template.register('coffee', require('coffeekup'));

console.log("* compiling %s …", filepath);
template.compile(filepath, {}, function (err, ok) {
    console.log("error:", err);
    console.log("ok:", ok);
console.log("* rendering %s …", filepath);
    template.render(filepath, {}, function (err, data) {
        console.log("error:", err);
        console.log("data:", data);
    });
});
