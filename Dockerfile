ARG VERSION=1.15.0
ARG HYPERKUBE_VERS=${VERSION}
ARG CONSUL_TEMPLATE_VERS=0.21.0
ARG ALPINE_VERS=alpine-3.10_glibc-2.29

FROM gcr.io/google-containers/hyperkube-amd64:v${HYPERKUBE_VERS} AS hyperkube
FROM hashicorp/consul-template:${CONSUL_TEMPLATE_VERS}-scratch AS consul-template
FROM frolvlad/alpine-glibc:${ALPINE_VERS}

COPY --from=hyperkube /hyperkube /usr/local/bin
COPY --from=consul-template /consul-template /usr/local/bin

RUN ln -s /usr/local/bin/consul-template /consul-template \
    && ln -s /usr/local/bin/hyperkube /hyperkube \
    && ln -s /usr/local/bin/hyperkube /apiserver \
    && ln -s /usr/local/bin/hyperkube /cloud-controller-manager \
    && ln -s /usr/local/bin/hyperkube /controller-manager \
    && ln -s /usr/local/bin/hyperkube /kubectl \
    && ln -s /usr/local/bin/hyperkube /kubelet \
    && ln -s /usr/local/bin/hyperkube /proxy \
    && ln -s /usr/local/bin/hyperkube /scheduler \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/cloud-controller-manager \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kube-apiserver \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kube-controller-manager \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kube-proxy \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kube-scheduler \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kubectl \
    && ln -s /usr/local/bin/hyperkube /usr/local/bin/kubelet

RUN printf "\n### Check versions, permissions and dependencies of binaries ###\n\n" \
    && echo "Alpine Linux: $(cat /etc/alpine-release)" \
    && consul-template -version \
    && hyperkube kubelet --version

ARG VERSION
ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="Mark BinLab <mark.binlab@gmail.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.name="hyperkube" \
      org.label-schema.description="Hyperkube based on Alpine Linux with Consul-template" \
      org.label-schema.usage="https://github.com/binlab/docker-hyperkube/blob/v${VERSION}/README.md" \
      org.label-schema.url="https://github.com/binlab/docker-hyperkube" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="git@github.com:binlab/docker-hyperkube.git" \
      org.label-schema.vendor="BinLab" \
      org.label-schema.version=${VERSION} \
      org.label-schema.schema-version="1.0"
