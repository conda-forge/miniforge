ARG IMAGE_TO_TEST=miniforge3
FROM ${IMAGE_TO_TEST}

COPY tests /tmp/tests
RUN for f in /tmp/tests/*; do \
        echo "Executing $f"; \
        $f; \
    done