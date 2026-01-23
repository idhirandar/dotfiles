import csv
import gi
import os
import remmina

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib



class PluginExport:
    def __init__(self):
        self.name = "Bulk export"
        self.type = "tool"
        self.description = "Bulk Export"
        self.version  = "1.0"

    def exec_func(self):
        try:
            output = open(remmina.get_datadir() + "/bulk_exported_profiles.csv" , 'w', newline='')
        except:
            remmina.show_dialog(0, 1, "Error creating bulk export file")
            return
        writer = csv.writer(output)
        row = []

        writer.writerow(["[bulk_remmina]"])
        for file in os.listdir(remmina.get_datadir()):
            if not os.path.isfile(remmina.get_datadir() + "/" + file) or ".remmina" not in file:
                continue
            try:
                current = open(remmina.get_datadir() + "/" + file)   
            except:
                remmina.show_dialog(0, 1, "Failed to read profile for export")
                return
            
            row = []
            lines = current.readlines()
            row.append(file)
            for line in lines:
                row.append(line.strip())
            writer.writerow(row)
            current.close()

        output.close()
        remmina.show_dialog(0, 1, "Bulk export completed. Written to " + remmina.get_datadir() + "/bulk_exported_profiles.csv")

class PluginImport:
    def __init__(self):
        self.name = "Bulk import"
        self.type = "tool"
        self.description = "Bulk Import"
        self.version  = "1.0"

    def exec_func(self):
        win = remmina.get_main_window()
        dialog = Gtk.FileChooserDialog("Please choose a file", win,
            Gtk.FileChooserAction.OPEN,
            (Gtk.STOCK_CANCEL, Gtk.ResponseType.CANCEL,
             Gtk.STOCK_OPEN, Gtk.ResponseType.OK))

        response = dialog.run()
        if response == Gtk.ResponseType.OK:
            file_path = dialog.get_filename()
            try:
                file = open(file_path)
            except:
                remmina.show_dialog(0, 1, "Unable to open file to import")
                return
            first = True
            for line in file.readlines():
                if first:
                    if (line != "[bulk_remmina]\n"):
                        print("line is: " + line)
                        remmina.show_dialog(0, 1, "Invalid format for import")
                        dialog.destroy()
                        return
                    first = False
                    continue
                fields = line.split(",")
                filename = fields[0]
                print(filename)
                try:
                    new_file = open(remmina.get_datadir() + "/" + filename, "w")
                except:
                    remmina.show_dialog(0, 1, "Unable to create new profile file")
                    return
                for field in fields[1:]:
                    new_file.write(field + "\n")
                new_file.close()
            file.close()
            remmina.show_dialog(0, 1, "Bulk import completed. Toggle view or refresh Remmina to see imported profiles")
        dialog.destroy()



myExportPlugin = PluginExport()
remmina.register_plugin(myExportPlugin)


myImportPlugin = PluginImport()
remmina.register_plugin(myImportPlugin)
