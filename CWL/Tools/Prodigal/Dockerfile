FROM centos:centos7

LABEL maintainer="Ekaterina Sakharova <kates@ebi.ac.uk>"

RUN yum -y update; yum clean all
RUN yum -y install gcc git make; yum clean all
RUN git clone https://github.com/hyattpd/Prodigal.git && cd Prodigal && make install


CMD ["prodigal"]