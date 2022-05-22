-- sith-svc-template.dhall

let kubernetes =
     https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall

let ConfigSvc = ../types/sith-config-svc.dhall

let svc =
  λ(config : ConfigSvc.Type) →
  kubernetes.Service::{
    , metadata = kubernetes.ObjectMeta::{ 
      name = Some config.name, labels = Some (toMap { app = config.app }) 
      }
    , spec = Some kubernetes.ServiceSpec::{
      , ports = Some
        [ kubernetes.ServicePort::{
          , name = config.portName
          , targetPort = config.targetPort
          , port = config.port
          }
        ]
      , selector = Some (toMap { app = config.app })
    }
  }

in svc