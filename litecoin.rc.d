#!/bin/sh

# PROVIDE: litecoin
# REQUIRE: LOGIN
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf.local or /etc/rc.conf
# to enable this service:
#
# litecoin_enable (bool):	Set to NO by default.
#				Set it to YES to enable litecoin.
# litecoin_config (path):	Set to /usr/local/etc/litecoin.conf
#				by default.
# litecoin_user:	The user account litecoin daemon runs as
#				It uses 'root' user by default.
# litecoin_group:	The group account litecoin daemon runs as
#				It uses 'wheel' group by default.
# litecoin_datadir (str):	Default to "/var/db/litecoin"
#				Base data directory.

. /etc/rc.subr

name=litecoin
rcvar=litecoin_enable

: ${litecoin_enable:=NO}
: ${litecoin_config=/usr/local/etc/litecoin.conf}
: ${litecoin_datadir=/var/db/litecoin}
: ${litecoin_user="root"}
: ${litecoin_group="wheel"}

required_files=${litecoin_config}
command=/usr/local/bin/litecoind
litecoin_chdir=${litecoin_datadir}
pidfile="${litecoin_datadir}/litecoind.pid"
stop_cmd=litecoin_stop
command_args="-conf=${litecoin_config} -datadir=${litecoin_datadir} -noupnp -daemon -pid=${pidfile}"
start_precmd="${name}_prestart"

litecoin_create_datadir()
{
	echo "Creating data directory"
	eval mkdir -p ${litecoin_datadir}
	[ $? -eq 0 ] && chown -R ${litecoin_user}:${litecoin_group} ${litecoin_datadir}
}

litecoin_prestart()
{
	if [ ! -d "${litecoin_datadir}/." ]; then
		litecoin_create_datadir || return 1
	fi
}

litecoin_requirepidfile()
{
	if [ ! "0`check_pidfile ${pidfile} ${command}`" -gt 1 ]; then
		echo "${name} not running? (check $pidfile)."
		exit 1
	fi
}

litecoin_stop()
{
    litecoin_requirepidfile

	echo "Stopping ${name}."
	eval ${command} -conf=${litecoin_config} -datadir=${litecoin_datadir} stop
	wait_for_pids ${rc_pid}
}

load_rc_config $name
run_rc_command "$1"
