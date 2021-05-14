#!/bin/bash
#
set -x
# 

SetPermission () {

    chown -Rf apache:apache /var/www/html/plugins

}

RemoveOldPlugin() {

	if [ -z $1 ]
	then
		return "Use: $0 directory"
	fi

	if [ ! -d /var/www/html/plugins/$1 ]
	then

		echo "Directory not found."

	else

		rm -rf /var/www/html/plugins/$1

	fi

}

PluginModifications() {

	RemoveOldPlugin Mod

	curl --progress-bar -L "https://github.com/stdonato/glpi-modifications/archive/2.0.2.tar.gz" | tar -zxf - -C /var/www/html/plugins/

	mv /var/www/html/plugins/glpi-modifications-2.0.2 /var/www/html/plugins/Mod

}




PluginTelegramBot() {

	RemoveOldPlugin telegrambot

	curl --progress-bar -L "https://github.com/pluginsGLPI/telegrambot/releases/download/2.0.0/glpi-telegrambot-2.0.0.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}

PluginPDF() {

	RemoveOldPlugin pdf

	curl --progress-bar -L "https://forge.glpi-project.org/attachments/download/2335/glpi-pdf-2.0.0.tar.gz" | tar -zxf - -C /var/www/html/plugins/

}


PluginOCS() {

	RemoveOldPlugin ocsinventoryng

    curl --progress-bar -L "https://github.com/pluginsGLPI/ocsinventoryng/releases/download/1.7.3/glpi-ocsinventoryng-1.7.3.tar.gz" | tar -zxf - -C /var/www/html/plugins/

}

PluginFusion() {

	RemoveOldPlugin fusioninventory

	curl --progress-bar -L "https://github.com/fusioninventory/fusioninventory-for-glpi/releases/download/glpi9.5%2B3.0/fusioninventory-9.5+3.0.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}


PluginDataInjection() {

	RemoveOldPlugin datainjection

    curl --progress-bar -L "https://github.com/pluginsGLPI/datainjection/releases/download/2.9.0/glpi-datainjection-2.9.0.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}

PluginFields() {

	RemoveOldPlugin fields

	curl --progress-bar -L "https://github.com/pluginsGLPI/fields/releases/download/1.12.4/glpi-fields-1.12.4.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}


PluginTasklists() {

	RemoveOldPlugin tasklists

	curl --progress-bar -L "https://github.com/InfotelGLPI/tasklists/releases/download/1.6.2/glpi-tasklists-1.6.2.tar.gz" | tar -zxf - -C /var/www/html/plugins/ 

}


PluginFormCreator() {

	RemoveOldPlugin formcreator

	curl --progress-bar -L "https://github.com/pluginsGLPI/formcreator/releases/download/v2.11.2/glpi-formcreator-2.11.2.tar.bz2" | tar -jxf - -C /var/www/html/plugins/ 

}


PluginBehaviors() {

	RemoveOldPlugin behaviors

	curl --progress-bar -L "https://forge.glpi-project.org/attachments/download/2333/glpi-behaviors-2.4.2.tar.gz" | tar -zxf - -C /var/www/html/plugins/

}

PluginCosts() {

	RemoveOldPlugin costs

	curl --progress-bar -L "https://github.com/ticgal/costs/releases/download/1.3.0/glpi-costs-1.3.0.tar.tgz" | tar -zxf - -C /var/www/html/plugins/

}


PluginTag() {

	RemoveOldPlugin tag

	curl --progress-bar -L "https://github.com/pluginsGLPI/tag/releases/download/2.8.1/glpi-tag-2.8.1.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}

PluginGenericObject() {

	RemoveOldPlugin genericobject 

	curl --progress-bar -L "https://github.com/pluginsGLPI/genericobject/releases/download/2.10.1/glpi-genericobject-2.10.1.tar.bz2" | tar -jxf - -C /var/www/html/plugins/

}


InstallPlugins() {

	if [ ! -z $PLUGINS ]
	then
		
		LIST=$(echo $PLUGINS | sed "s/,/ /g")

		for i in $LIST
		do

			case $i in

				glpi-modifications)

					PluginModifications

				;;

				glpi-telegrambot)

					PluginTelelgramBot

				;;

				glpi-pdf)

					PluginPDF

				;;

				glpi-ocsinventoryng)

				    PluginOCS

				;;

				glpi-fusioninventory)

					PluginFusion

				;;

				glpi-datainjection)

					PluginDataInjection

				;;

				glpi-fields) 

					PluginFields

				;;

				glpi-tasklists)

					PluginTasklists

				;;

				glpi-formcreator)

					PluginFormCreator

				;;

				glpi-costs)

					PluginCosts

				;;

				glpi-tag) 

					PluginTag

				;;

				glpi-genericobject)

					PluginGenericObject

				;;

				all)
					# PluginModifications
					PluginTelegramBot
					PluginPDF
					PluginOCS
					PluginDataInjection
					PluginFields
					PluginTasklists
					PluginFormCreator
					PluginCosts
					PluginTag
					PluginGenericObject
					PluginFusion

				;;

				*)
				
					echo "Use: $0 <plugin_name> "
					echo "Available: "
					echo " all (all plugins above)"
					echo " glpi-modifications"
					echo " glpi-telegrambot"
					echo " glpi-pdf"
					echo " glpi-ocsinventoryng"
					echo " glpi-datainjection"
					echo " glpi-fields"
					echo " glpi-tasklists"
					echo " glpi-formcreator"
					echo " glpi-costs"
					echo " glpi-tags"
					echo " glpi-genericobject"
					echo " glpi-fusioninventory"

				;;

			esac	

		done

	fi

}

#
#
InstallPlugins
#
#
SetPermission
#
#