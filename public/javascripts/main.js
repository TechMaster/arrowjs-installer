var socket = io();

socket.on('checking', function (data) {
    if (data.postgres) {
        $('.btn-install-postgres').remove();
        $('#postgres-status').text("Postgres are installing ...").css('color', 'blue');
    }

    if (data.redis) {
        $('.btn-install-redis').remove();
        $('#redis-status').text("Redis are installing ...").css('color', 'blue');
    }

    if (data.nginx) {
        $('.btn-install-nginx').remove();
        $('#nginx-status').text("Nginx are installing ...").css('color', 'blue');
    }

    if (data.pm2) {
        $('.btn-install-pm2').remove();
        $('#pm2-status').text("PM2 are installing ...").css('color', 'blue');
    }
});

socket.on('install_postgres_process', function (data) {
    $('#postgres-process').append(data);
    $('#postgres-process').scrollTop(999999);
});

socket.on('install_postgres_completed', function (data) {
    $('#postgres-status').text('Postgres installation has completed').css('color', 'green');
});

socket.on('install_redis_process', function (data) {
    $('#redis-process').append(data);
    $('#redis-process').scrollTop(999999);
});

socket.on('install_redis_completed', function (data) {
    $('#redis-status').text('Redis installation has completed').css('color', 'green');
});

socket.on('install_nginx_process', function (data) {
    $('#nginx-process').append(data);
    $('#nginx-process').scrollTop(999999);
});

socket.on('install_nginx_completed', function (data) {
    $('#nginx-status').text('Nginx installation has completed').css('color', 'green');
});

socket.on('install_pm2_process', function (data) {
    $('#pm2-process').append(data);
    $('#pm2-process').scrollTop(999999);
});

socket.on('install_pm2_completed', function (data) {
    $('#pm2-status').text('PM2 installation has completed').css('color', 'green');
});

function installPostgres(button) {
    $(button).remove();
    $('#postgres-status').text("Installing Postgres ...").css('color', 'blue');
    $('#postgres-process').css('display', 'block');

    socket.emit('install_postgres', '');
}

function installRedis(button) {
    $(button).remove();
    $('#redis-status').text("Installing Redis ...").css('color', 'blue');
    $('#redis-process').css('display', 'block');

    socket.emit('install_redis', '');
}

function installNginx(button) {
    $(button).remove();
    $('#nginx-status').text("Installing Nginx ...").css('color', 'blue');
    $('#nginx-process').css('display', 'block');

    socket.emit('install_nginx', '');
}

function installPm2(button) {
    $(button).remove();
    $('#pm2-status').text("Installing PM2 ...").css('color', 'blue');
    $('#pm2-process').css('display', 'block');

    socket.emit('install_pm2', '');
}

function restartRedis() {
    socket.emit('restart_redis', '');
}

$('#toggle-redis').on('change', function () {
    //$('.btn-restart-redis').toggleClass('disabled');
    if ($(this).is(':checked')) {
        socket.emit('start_redis', '');
    } else {
        socket.emit('stop_redis', '');
    }
});

