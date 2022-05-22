-- sith-all-template.dhall

let Config = ../types/sith-config.dhall

let kubernetes = https://raw.githubusercontent.com/dhall-lang/dhall-kubernetes/v6.0.0/1.21/package.dhall

let ManifestUnion : Type = < Svc : kubernetes.Service.Type | Deploy : kubernetes.Deployment.Type | Ing : kubernetes.Ingress.Type >

let deployment = ./sith-deploy-template.dhall

let service = ./sith-svc-template.dhall

let ingress = ./sith-ingress-template.dhall


let items =
  λ(config : Config) → 
    [ 
      ManifestUnion.Deploy (deployment config.deploy)
    , ManifestUnion.Svc (service config.svc)
    , ManifestUnion.Ing (ingress config.ing)
    ]

in items
