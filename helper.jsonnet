function (
    cmd,
    img,
    ns="argocd",
    saname="argocd-helper",
    cntname="helper",
)
    [
    {
        "apiVersion": "v1",
        "kind": "ServiceAccount",
        "metadata": {
            "name": saname,
            "namespace": ns
        },
    },
    {
        "apiVersion": "rbac.authorization.k8s.io/v1",
        "kind": "ClusterRoleBinding",
        "metadata": {
            "name": saname
        },
        "roleRef": {
            "apiGroup": "rbac.authorization.k8s.io",
            "kind": "ClusterRole",
            "name": "cluster-admin",
        },
        "subjects": [
            {
                "kind": "ServiceAccount",
                "name": saname,
                "namespace": ns,
            }
        ]
    },
    {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {
            "name": saname,
            "namespace": ns
        },
        "spec": {
            "template": {
                "spec": {
                    "serviceAccountName": saname,
                    "containers": [
                        {
                            "name": cntname,
                            "image": img,
                            "command": [
                                "/bin/sh",
                                "-c",
                                "$C",
                            ],
                            "env": [
                                {
                                    "name": "C",
                                    "value": cmd,
                                }
                            ]
                        }
                    ],
                    "restartPolicy": "never",
                }
            }
        }
    }
    ]
