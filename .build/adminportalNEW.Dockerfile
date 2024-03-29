FROM node:18.14.1 as builder
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH

ENV NODE_ENV=dev
COPY adminportal/ ./
# RUN npm install
RUN npm ci
RUN npm run build


EXPOSE 3000

FROM nginx:1.19.4-alpine

# update nginx conf
RUN rm -rf /etc/nginx/conf.d
COPY build/conf /etc/nginx

# copy static files
COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]