FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf


######
COPY start.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/start.sh
RUN ln -s usr/local/bin/start.sh / # backwards compat
ENTRYPOINT ["/usr/local/bin/start.sh"]

## starting nginx 
CMD ["nginx", "-g", "daemon off;"]


# Expose apache.
EXPOSE 80

