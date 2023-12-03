import St from "gi://St";
import Gio from "gi://Gio";
import GObject from "gi://GObject";
import Clutter from "gi://Clutter";

import { PopupMenuItem } from 'resource:///org/gnome/shell/ui/popupMenu.js'
import { gettext as _ } from "resource:///org/gnome/shell/extensions/extension.js";

import { Monitor } from "../base/monitor.js";
import { getExtensionObject } from "../../extension.js";

const MENU_COLUMNS = 2;

export const KubeCluster = GObject.registerClass(
  class KubeCluster extends Monitor {
    _init(name, uuid) {
      super._init(name, uuid);
      this._timeout = null;
      this.settings = getExtensionObject().getSettings(
        "io.k8s.framework.gnome-cloud-cicd"
      );

      this._refreshDelay = this.settings.get_int("refresh-delay");

      const gicon = Gio.icon_new_for_string(
        getExtensionObject().path + "/icons/google-kubernetes.svg"
      );
      //const panelIcon = (name = "docker-symbolic", styleClass = "system-status-icon") => new St.Icon({ gicon: gioIcon(name), style_class: styleClass, icon_size: "16" });
      this.icon = new St.Icon({
        gicon: gicon,
        style_class: "system-status-icon",
        icon_size: "16",
      });
      this.addChild(this.icon);
      this.addChild(
        new St.Label({
          text: "Kube",
          style_class: "panel-label",
          y_align: Clutter.ActorAlign.CENTER,
        })
      );
      this._buildMenu();
    }

    _buildMenu() {
      this.settings.connect("changed::refresh-delay", this._refreshCount);

      // Custom Docker icon as menu button
      const hbox = new St.BoxLayout({ style_class: "panel-status-menu-box" });
      const gicon = Gio.icon_new_for_string(
        getExtensionObject().path + "/icons/google-kubernetes.svg"
      );
      //const panelIcon = (name = "docker-symbolic", styleClass = "system-status-icon") => new St.Icon({ gicon: gioIcon(name), style_class: styleClass, icon_size: "16" });
      const dockerIcon = new St.Icon({
        gicon: gicon,
        style_class: "system-status-icon",
        icon_size: "16",
      });
      const loading = _("Loading...");
      this.buttonText = new St.Label({
        text: loading,
        style: "margin-top:4px;",
      });

      hbox.add_child(dockerIcon);
      hbox.add_child(this.buttonText);
      this.add_child(hbox);
      this.menu.connect("open-state-changed", this._refreshMenu.bind(this));
      this.menu.addMenuItem(new PopupMenuItem(loading));

      this._refreshCount();
        //   if (Docker.hasPodman || Docker.hasDocker) {
        //     this.show();
        //   }
    }

    destroy() {
      super.destroy();
      this.clearLoop();
    }

    async _refreshCount() {
      try {
        // If the extension is not enabled but we have already set a timeout, it means this function
        // is called by the timeout after the extension was disabled, we should just bail out and
        // clear the loop to avoid a race condition infinitely spamming logs about St.Label not longer being accessible
        this.clearLoop();

        // const dockerCount = await Docker.getContainerCount();
        // this._updateCountLabel(dockerCount);

        // Allow setting a value of 0 to disable background refresh in the settings
        if (this._refreshDelay > 0) {
          this._timeout = GLib.timeout_add_seconds(
            GLib.PRIORITY_DEFAULT_IDLE,
            this._refreshDelay,
            this._refreshCount
          );
        }
      } catch (err) {
        logError(err);
        this.clearLoop();
      }
    }

    _updateCountLabel(count) {
      if (this.buttonText.get_text() !== count) {
        this.buttonText.set_text(count.toString(10));
      }
    }

    clearLoop() {
      if (this._timeout) {
        GLib.source_remove(this._timeout);
      }

      this._timeout = null;
    }
    async _refreshMenu() {
        try {
          if (this.menu.isOpen) {
            // const containers = await Docker.getContainers();
            // this._updateCountLabel(
            //   containers.filter((container) => isContainerUp(container)).length
            // );
            // this._feedMenu(containers).catch((e) =>
            //   this.menu.addMenuItem(new PopupMenuItem(e.message))
            // );
          }
        } catch (e) {
          logError(e);
        }
      }
  }
);
