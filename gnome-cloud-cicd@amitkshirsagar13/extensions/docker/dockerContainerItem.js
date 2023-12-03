"use strict";

import St from 'gi://St';
import Atk from 'gi://Atk';
import Gio from 'gi://Gio';
import GObject from 'gi://GObject';
import { PopupSubMenuMenuItem } from 'resource:///org/gnome/shell/ui/popupMenu.js';
import { DockerMenuItem } from './dockerMenuItem.js';
import { buildIcon } from '../base/ui-component-store.js';
import { ActionIcon } from '../base/actionIcon.js';

/**
 * Create Gio.icon based St.Icon
 *
 * @param {String} name The name of the icon (filename without extension)
 * @param {String} styleClass The style of the icon
 *
 * @return {Object} an St.Icon instance
 */
const menuIcon = (containerName, name = "docker-container-unavailable-symbolic", styleClass = "system-status-icon") => {
  const menuIconWidget = new ActionIcon(`${containerName}-${name}`, `${containerName}-${name}`);
  menuIconWidget.addChild(buildIcon(name, styleClass));
  return menuIconWidget;
}

/**
 * Get the status of a container from the status message obtained with the docker command
 *
 * @param {String} statusMessage The status message
 *
 * @return {String} The status in ['running', 'paused', 'stopped']
 */
const getStatus = (statusMessage) => {
  let status = "stopped";
  if (statusMessage.indexOf("Up") > -1) status = "running";
  if (statusMessage.indexOf("Paused") > -1) status = "paused";

  return status;
};

// Menu entry representing a Docker container
export const DockerContainerItem = GObject.registerClass(
  class DockerContainerItem extends St.Widget {
    _init(projectName, name, containerStatusMessage) {
      super._init({
          reactive: true,
          can_focus: true,
          track_hover: true,
          style_class: 'panel-button',
          accessible_name: name,
          accessible_role: Atk.Role.MENU,
          x_expand: true,
          y_expand: true,

      });
      let hbox = new St.BoxLayout();
      this.add_child(hbox);
      this.box = hbox;

      switch (getStatus(containerStatusMessage)) {
        case "stopped":
          this.insert_child_at_index(
            menuIcon("docker-container-symbolic", "status-stopped"),
            1
          );

          this.menu.addMenuItem(
            new DockerMenuItem(
              containerName,
              "start",
              menuIcon("docker-container-start-symbolic")
            )
          );
          break;

        case "running":
          this.addChild(menuIcon("docker-container-symbolic", "status-running"));
          this.addChild(menuIcon("docker-container-pause-symbolic", "status-running"));
          this.addChild(menuIcon("docker-container-stop-symbolic", "status-running"));
          this.addChild(menuIcon("docker-container-restart-symbolic", "status-running"));
          this.addChild(menuIcon("docker-container-exec-symbolic", "status-running"));
          // this.insert_child_at_index(
          //   menuIcon("docker-container-symbolic", "status-running"),
          //   1
          // );

          // this.menu.addMenuItem(
          //   new DockerMenuItem(
          //     containerName,
          //     "pause",
          //     menuIcon("docker-container-pause-symbolic")
          //   )
          // );

          // this.menu.addMenuItem(
          //   new DockerMenuItem(
          //     containerName,
          //     "stop",
          //     menuIcon("docker-container-stop-symbolic")
          //   )
          // );

          // this.menu.addMenuItem(
          //   new DockerMenuItem(
          //     containerName,
          //     "restart",
          //     menuIcon("docker-container-restart-symbolic")
          //   )
          // );

          // this.menu.addMenuItem(
          //   new DockerMenuItem(
          //     containerName,
          //     "exec",
          //     menuIcon("docker-container-exec-symbolic")
          //   )
          // );
          break;

        case "paused":
          this.insert_child_at_index(
            menuIcon("docker-container-symbolic", "status-paused"),
            1
          );

          this.menu.addMenuItem(
            new DockerMenuItem(
              containerName,
              "unpause",
              menuIcon("docker-container-start-symbolic")
            )
          );
          break;

        default:
          this.insert_child_at_index(
            menuIcon(
              "docker-container-unavailable-symbolic",
              "status-undefined"
            ),
            1
          );
          break;
      }

      this.addChild(menuIcon("docker-container-logs-symbolic", "status-running"));
      // this.menu.addMenuItem(
      //   new DockerMenuItem(
      //     containerName,
      //     "logs",
      //     menuIcon("docker-container-logs-symbolic")
      //   )
      // );
    }
    addChild(child) {
      if (this.box) {
          this.box.add_child(child);
      } else {
          super.add_child(child);
      }
    }
  }
);
