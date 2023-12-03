import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import { GnomeCloudCicdContainer } from './extensions/container.js';
import { Indicator } from './extensions/indicator/indicatorMonitor.js'
import { DockerMenu } from './extensions/docker/dockerMonitor.js';
import { KubeCluster } from './extensions/kube/kubeMonitor.js';

export const getExtensionObject = () => Extension.lookupByUUID('gnome-cloud-cicd@amitkshirsagar13');

let depFailures = [];
let missingLibs = [];

const MenuPosition = {
    LEFT_EDGE: 0,
    LEFT: 1,
    CENTER: 2,
    RIGHT: 3,
    RIGHT_EDGE: 4,
};

class GnomeCloudCicd {
    constructor() {
        this.container = new GnomeCloudCicdContainer();
        this.container.addMonitor(new Indicator('Indicator', 'indicator'));
        this.container.addMonitor(new DockerMenu('Docker Containers', 'docker-containers'));
        this.container.addMonitor(new KubeCluster('Kube Clusters', 'kube-clusters'));
    }

    destroy() {
        this.container.monitors.forEach(monitor => monitor.destroy());
        this.container.destroy();
    }
}

export default class GnomeCloudCicdExtension extends Extension {
    constructor(metadata) {
        super(metadata);
        this.initTranslations();
    }

    enable() {
        this.gnomeCloudCicd = new GnomeCloudCicd();
        Main.panel.addToStatusArea('GnomeCloudCicd', this.gnomeCloudCicd.container, 1, 'left');
    }

    disable() {
        this.gnomeCloudCicd.destroy();
        this.gnomeCloudCicd = null;
    }
}
