var socket_website = {};
var child_process = require('child_process');

socket_website.create = function (socket, form) {
    var use_nginx = '';
    if(form[5]){
        use_nginx = 'yes';
    }
    var create_process = child_process.spawn('./shell_scripts/website/new_website.sh', [_osId, _osVersion, form[0].value, form[1].value, form[2].value, form[3].value, form[4].value, use_nginx]);

    create_process.stdout.on('data', function (data) {
        socket.emit('create_website_process', data.toString());
    });

    create_process.stderr.on('data', function (data) {
        socket.emit('create_website_process', data.toString());
    });

    create_process.on('close', function (code) {
        socket.emit('create_website_completed', code);

        _creatingWebsite = false;
    });
};

module.exports = socket_website;