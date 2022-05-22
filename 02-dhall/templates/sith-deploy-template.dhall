let kubernetes =
     https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall

let ConfigDeploy = ../types/sith-config-deploy.dhall

let null = https://prelude.dhall-lang.org/v19.0.0/Optional/null.dhall

-- TODO env var
let deployment =
  λ(config : ConfigDeploy.Type) → 
  kubernetes.Deployment::{
  , metadata = kubernetes.ObjectMeta::{ name = Some config.name, labels = Some (toMap { app = config.app }) }
  , spec = Some kubernetes.DeploymentSpec::{
    , selector = kubernetes.LabelSelector::{
      , matchLabels = Some (toMap { app = config.app })
      }
    , replicas = Some config.replicas
    , template = kubernetes.PodTemplateSpec::{
      , metadata = Some kubernetes.ObjectMeta::{ 
        name = Some config.name,
        labels = Some (toMap { app = config.app })
      }
      , spec = Some kubernetes.PodSpec::{
        , containers =
          [ kubernetes.Container::{
            , name = config.name
            , image = Some config.image
            , env = if null Text (config.environnement)
              then None (List kubernetes.EnvVar.Type)
              else Some [ kubernetes.EnvVar::{ name = "ENV", value = config.environnement } ] 
            , ports = Some [ kubernetes.ContainerPort::{ 
              containerPort = config.containerPort,
              name = config.portName,
              } ]
            , resources = Some { 
                requests = Some (toMap { cpu = config.resources.requests.cpu, memory = config.resources.requests.memory }) 
              , limits = Some (toMap { cpu = config.resources.limits.cpu, memory = config.resources.limits.memory }) 
              }
            , livenessProbe = Some kubernetes.Probe::{ 
              httpGet = Some kubernetes.HTTPGetAction::{ path = Some config.livenessProbe.path, port = config.livenessProbe.port  } 
            }
            }
          ]
        }
      }
    }
  }

in deployment