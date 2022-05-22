let kubernetes =
     https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall

let ConfigIngress = ../types/sith-config-ingress.dhall

let ingress =
  λ(config : ConfigIngress.Type) →
  kubernetes.Ingress::{
    , metadata = kubernetes.ObjectMeta::{
      , labels = Some (toMap { app = config.app })
      , name = Some config.name
      }
    , spec = Some kubernetes.IngressSpec::{
      , rules = Some [ kubernetes.IngressRule::{ 
            host = Some config.rule.host
          , http = Some { 
              paths =
              [ kubernetes.HTTPIngressPath::{ 
                  backend = kubernetes.IngressBackend::{ 
                    service = Some kubernetes.IngressServiceBackend::
                    { name = config.rule.serviceName
                    , port = Some kubernetes.ServiceBackendPort::{ number = config.rule.servicePort.number, name = config.rule.servicePort.name }
                    }
                  }
                , path = config.rule.path
                , pathType = Some "ImplementationSpecific"
                }
              ]
            }
          }
        ]
      }
    }

in ingress