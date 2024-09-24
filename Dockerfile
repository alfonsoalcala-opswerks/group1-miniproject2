FROM ubuntu:latest
COPY shift_sched.sh .
RUN chmod +x shift_sched.sh
CMD ["./shift_sched.sh"]

