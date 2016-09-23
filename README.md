# VA Appeals Developer Environment

This repository is intended to be a _personal_ dockerized developer environment for the VA Digital Service Appeals team. The goal is to have the developer environment quickly setup without the hassle of installing PG, Redis, etc...

## How to start

 1. Git clone this repo.

 1. Run `cd dev-img && sh build.sh`. This will take awhile because we are building the rails container.

 1. Go back to the parent folder and run `sh appeals.sh`. At this point, you have started the VA Appeals developer environment.

 1. Now you can attach into the Case Cert or E-Folder docker container to develop the rails application. To attach to the container, run
  - `docker exec -it appeals-efolder-dev /bin/bash` (make it into an alias)

## How this works

This environment uses __Docker Compose__ to link several containers together
to replicate the VA Appeals application environment.

The Redis and Postgres images are from Dockerhub. The Case Certification
and E-Folder Express image is from an Ubuntu 16.04 based image with Ruby
support (along with a few other things).

```
+---------------------------------------------------+
| Linked by Docker Compose                          |
|    +---------------+        +---------------+     |
|    |  Redis ~2.8   |        | Case          |     |
|    |               |        | Certification |     |
|    +---------------+        ----------------+     |
|                                                   |
|    +---------------+        +---------------+     |
|    | Postgres ~9.3 |        |  E-Folder     |     |
|    |               |        |  Express      |     |
|    +---------------+        +---------------+     |
+---------------------------------------------------+
```
