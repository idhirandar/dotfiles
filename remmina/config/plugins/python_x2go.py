import sys
import remmina
import enum
import gi
import inspect
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib
import gevent
from multiprocessing import Process
import sys
import x2go


class VncFeature:
    PrefQuality = 1
    PrefViewonly = 2
    PrefDisableserverinput = 3
    ToolRefresh = 4
    ToolChat = 5
    ToolSendCtrlAltDel = 6
    Scale = 7
    Unfocus = 8

class VncData:
    def __init__(self):
        self.connected = False
        self.running = False
        self.auth_called = False
        self.auth_first = False
        self.drawing_area = False
        self.vnc_buffer = False
        self.rgb_buffer = False

class Plugin:

    def __init__(self):
        # This constructor is called before Remmina attempts to register the plugin since it this class has to be instantiated before registering it.
        self.name = "New X2Go Python"
        # One of possible values: "pref", "tool", "entry", "protocol" or "secret". This value decides which methods are expected to be defined
        # in this class.
        self.type = "protocol"
        self.description = "Python X2Go Plugin"
        self.version = "1.0"
        self.icon_name = "org.remmina.Remmina-vnc-symbolic"
        self.icon_name_ssh = "org.remmina.Remmina-vnc-ssh-symbolic"
        # Specifies which settings are available for this protocol
        self.ssh_setting = remmina.PROTOCOL_SSH_SETTING_TUNNEL

        self.gpdata = VncData()
        self.sessionTypes = ("0", "KDE", "1","GNOME", "2","LXDE", "3","LXQt", "4","XFCE", "5","MATE", "6", "UNITY", "7", "CINNAMON", 
        "8", "TRINITY", "9", "OPENBOX", "10", "ICEWM", "11", "RDP connection", "12", "XDMCP")
        # Define the features this module supports:
        self.features = [
            remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_PREF, VncFeature.PrefViewonly, remmina.PROTOCOL_FEATURE_PREF_CHECK, "viewonly", None)
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_PREF, VncFeature.PrefDisableserverinput, remmina.PROTOCOL_SETTING_TYPE_CHECK, "disableserverinput", "Disable server input")
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_TOOL, VncFeature.ToolRefresh, "Refresh", "face-smile", None)
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_TOOL, VncFeature.ToolChat, "Open Chat…", "face-smile", None)
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_TOOL, VncFeature.ToolSendCtrlAltDel,     "Send Ctrl+Alt+Delete", None, None)
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_SCALE, VncFeature.Scale, None, None, None)
            ,remmina.Feature(remmina.PROTOCOL_FEATURE_TYPE_UNFOCUS, VncFeature.Unfocus, None, None, None)
        ]

        self.basic_settings = [
            remmina.Setting(type=remmina.PROTOCOL_SETTING_TYPE_SERVER,    name="server",    label="",             compact=False, opt1="_rfb._tcp",opt2=None)
            , remmina.Setting(type=remmina.PROTOCOL_SETTING_TYPE_TEXT,    name="proxy",     label="Repeater",     compact=False, opt1=None,       opt2=None)
            , remmina.Setting(type=remmina.PROTOCOL_SETTING_TYPE_TEXT,    name="username",  label="Username",     compact=False, opt1=None,       opt2=None)
            , remmina.Setting(type=remmina.PROTOCOL_SETTING_TYPE_PASSWORD,name="password",  label="User password",compact=False, opt1=None,       opt2=None)
            , remmina.Setting(type=remmina.PROTOCOL_SETTING_TYPE_SELECT,  name="sessionType",   label="Session type",      compact=False, opt1=self.sessionTypes, opt2=None)
        ]
        self.advanced_settings = [
        ]

    def init(self, gp):
        # this is called when the plugin is loaded from Remmina.
        cfile = gp.get_file()
        self.gpdata.disable_smooth_scrolling = cfile.get_setting(key="disablesmoothscrolling", default=False)
        self.gpdata.drawing_area = gp.get_viewport()
        return True

    def x2go_connection(self, gp):
        connection_file = gp.get_file()
        connectionName = connection_file.get_setting("name", "")
        server = connection_file.get_setting("server", "")
        userName = connection_file.get_setting("Username", "user")
        password = connection_file.get_setting("User pas", "")
        sessionIndx = connection_file.get_setting("Session typ", "0")
        sessionType = self.sessionTypes[self.sessionTypes.index(sessionIndx)+1]
        serverPort = remmina.public_get_server_port(server= server, defaultport= 22)

        try:
            s = x2go.session.X2GoSession(server=serverPort[0], port=serverPort[1])

            s.set_server(serverPort[0])
            s.set_port(serverPort[1])
            s.connect(userName, password)
            s.start(cmd=sessionType)

            s.set_session_window_title(connectionName)
            while True: gevent.sleep(1)
        except:
            print("failed to connect")

    def open_connection(self, gp):
        print(sys.version)
        # Is called when the user wants to open a connection whith this plugin.
        p = Process(target=self.x2go_connection, args=(gp,))
        p.start()

        return False

    def close_connection(self, gp):
        # The user requested to close the connection.
        remmina.protocol_plugin_signal_connection_closed(gp)

    def query_feature(self, gp, feature):
        # Remmina asks if the given feature is available (remember Features registered in the construtor).
        return True

    def map_event(self, gp):
        # This is called when the widget is again on screen.
        return True

    def unmap_event(self, gp):
        # This is called when the widget is again not being shown on screen anymore. Any intensive graphical output
        # can be halted.
        return True

    def call_feature(self, gp, feature):
        # Remmina asks to execute on of the features.

        if feature.type == remmina.PROTOCOL_FEATURE_TYPE_PREF and feature.id is VncFeature.PrefQuality:
            file = gp.get_file()

    def send_keystrokes(self, gp, strokes):
        # Remmina received a key stroke and wants to pass it to the remote.
        return True

    def get_plugin_screenshot(self, gp, data):
        # data is of type RemminaScreenshotData and should contain the raw pixels for the screenshot. Remmina takes care of storing it into a jpg.
        # Return True when a screenshot has been done. Otherwise False.
        return False

# Instantiate & Register
myPlugin = Plugin()
remmina.register_plugin(myPlugin)
