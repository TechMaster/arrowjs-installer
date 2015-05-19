var postgres_process = $('#postgres-process');
var postgres_status = $('#postgres-status');

var redis_process = $('#redis-process');
var redis_status = $('#redis-status');
var redis_toggle = $('#toggle-redis');
var redis_active_status = $('.redis-active-status');

var nginx_process = $('#nginx-process');
var nginx_status = $('#nginx-status');

var pm2_process = $('#pm2-process');
var pm2_status = $('#pm2-status');

var socket = io();

socket.on('checking', function (data) {
    if (data.postgres) {
        $('.btn-install-postgres').remove();
        postgres_status.text("Postgres are installing ...").css('color', 'blue');
    }

    if (data.redis) {
        $('.btn-install-redis').remove();
        redis_status.text("Redis are installing ...").css('color', 'blue');
    }

    if (data.nginx) {
        $('.btn-install-nginx').remove();
        nginx_status.text("Nginx are installing ...").css('color', 'blue');
    }

    if (data.pm2) {
        $('.btn-install-pm2').remove();
        pm2_status.text("PM2 are installing ...").css('color', 'blue');
    }
});

socket.on('install_postgres_process', function (data) {
    postgres_process.append(data);
    postgres_process.scrollTop(999999);
});

socket.on('install_postgres_completed', function (data) {
    postgres_status.text('Postgres installation has completed').css('color', 'green');
});

socket.on('install_redis_process', function (data) {
    redis_process.append(data);
    redis_process.scrollTop(999999);
});

socket.on('install_redis_completed', function (data) {
    redis_status.text('Redis installation has completed').css('color', 'green');
});

socket.on('install_nginx_process', function (data) {
    nginx_process.append(data);
    nginx_process.scrollTop(999999);
});

socket.on('install_nginx_completed', function (data) {
    nginx_status.text('Nginx installation has completed').css('color', 'green');
});

socket.on('install_pm2_process', function (data) {
    pm2_process.append(data);
    pm2_process.scrollTop(999999);
});

socket.on('install_pm2_completed', function (data) {
    pm2_status.text('PM2 installation has completed').css('color', 'green');
});

function installPostgres(button) {
    $(button).remove();
    postgres_status.text("Installing Postgres ...").css('color', 'blue');
    postgres_process.css('display', 'block');

    socket.emit('install_postgres', '');
}

function installRedis(button) {
    $(button).remove();
    redis_status.text("Installing Redis ...").css('color', 'blue');
    redis_process.css('display', 'block');

    socket.emit('install_redis', '');
}

function installNginx(button) {
    $(button).remove();
    nginx_status.text("Installing Nginx ...").css('color', 'blue');
    nginx_process.css('display', 'block');

    socket.emit('install_nginx', '');
}

function installPm2(button) {
    $(button).remove();
    pm2_status.text("Installing PM2 ...").css('color', 'blue');
    pm2_process.css('display', 'block');

    socket.emit('install_pm2', '');
}

redis_toggle.on('change', function () {
    //$('.btn-restart-redis').toggleClass('disabled');

    //todo: Lay duoc ket qua tra ve tu socket io khi da start service xong
    if ($(this).is(':checked')) {
        socket.emit('start_redis', '', function (result) {
            console.log('start result:' + result);
        });
    } else {
        socket.emit('stop_redis', '', function (result) {
            console.log('stop result:' + result);
        });
    }

    //redis_toggle.bootstrapToggle('disable');

    //if ($(this).is(':checked')) {
    //    socket.emit('start_redis', '');
    //} else {
    //    socket.emit('stop_redis', '');
    //}
});

