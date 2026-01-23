import gi
import remmina
import time
import os
gi.require_version('Secret', '1')
from gi.repository import Secret

# Schema in which passwords are stored
EXAMPLE_SCHEMA = Secret.Schema.new("org.remmina.Password",
	Secret.SchemaFlags.NONE,
	{
		"filename": Secret.SchemaAttributeType.STRING,
		"key": Secret.SchemaAttributeType.STRING,
	}
)

class PluginTool:
	def __init__(self):
		self.button = None
		# The name shown in the plugin list
		self.name = "Password Export Tool"
		self.type = "tool"
		# The description will be the label of the menu item!
		self.description = "Export all passwords"
		self.version  = "1.0"
		print("Loaded password export plugin")

	def exec_func(self):
		if (remmina.pref_get_value(key="use_primary_password") == "true" and (remmina.unlock_new() == 0)):
			print("Unlock failed")
			return              
		data_dir = remmina.get_datadir()
		for file in os.listdir(data_dir):
			if file.endswith(".remmina"):
				full_path = data_dir + "/" + file
				password = Secret.password_lookup_sync(EXAMPLE_SCHEMA, { "filename": full_path, "key": "password" },
						None)
				if (password):
					print(file + ":\t\t" + password)

myToolPlugin = PluginTool()
remmina.register_plugin(myToolPlugin)

