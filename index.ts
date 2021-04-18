import * as pulumi from "@pulumi/pulumi";
import * as digitalocean from "@pulumi/digitalocean";

const cfg = new pulumi.Config("jem-prod")

const tag = new digitalocean.Tag("jem-prod");

const vpc = new digitalocean.Vpc("jem-prod", {
    region: digitalocean.Regions.SFO3,
});

const relay = new digitalocean.Droplet("jem-prod-relay", {
    region: digitalocean.Regions.SFO3,
    privateNetworking: true,
    vpcUuid: vpc.id,
    size: digitalocean.DropletSlugs.DropletS2VCPU2GB,
    image: "ubuntu-20-04-x64",
    sshKeys: [cfg.requireSecret("ssh-fingerprint")],
    tags: [tag.id]
});

// const cluster = new digitalocean.KubernetesCluster("jem-prod-k8s", {
//     region: digitalocean.Regions.SFO3,
//     version: "latest",
//     nodePool: {
//         name: "default",
//         size: digitalocean.DropletSlugs.DropletS2VCPU2GB,
//         nodeCount: 1,
//     },
//     vpcUuid: vpc.id,
//     tags: [tag.id]
// });

// export const kubeconfig = cluster.kubeConfigs[0].rawConfig;
export const relayIp = relay.ipv4Address