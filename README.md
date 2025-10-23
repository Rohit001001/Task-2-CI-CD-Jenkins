# Task-2: Set up a Basic Jenkins Pipeline for Deploying an Application

This project demonstrates how to **dockerize a web application** and set up a **CI/CD pipeline using Jenkins**. It includes steps for creating a Dockerfile, Docker Compose setup, and integrating Jenkins to automatically build and deploy the application.

---

## Project Overview

- **Web Application:** A simple static website with HTML, CSS, JS files.
- **Docker:** Used to containerize the application for consistent deployment.
- **Docker Compose:** Used to manage and run multi-container Docker applications (if needed in future).
- **Jenkins CI/CD:** Automates building, testing, and deploying the Docker container.

---

## Folder Structure
```
Task-2-Set-up-a-basic-Jenkins-pipeline-for-deploying-an-application/
│
├── Dockerfile
├── docker-compose.yml
├── README.md
├── css/
├── js/
├── img/
├── scss/
├── index.html
├── cart.html
├── contact.html
├── shop.html
├── bestseller.html
├── single.html
├── cheackout.html
├── electronics-website-template.jpg
└── LICENSE.txt
```

---

## Step 1: Dockerfile

We created a **Dockerfile** to containerize the application:
```dockerfile
# Use official Nginx image as base
FROM nginx:alpine

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy your website files into Nginx html folder
COPY . /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
```

**Explanation:**
- `FROM nginx:alpine` → Uses lightweight Nginx image.
- `RUN rm -rf /usr/share/nginx/html/*` → Clears default Nginx content.
- `COPY . /usr/share/nginx/html` → Copies project files into container.
- `EXPOSE 80` → Opens port 80 for HTTP.
- `CMD ["nginx", "-g", "daemon off;"]` → Runs Nginx in the foreground.

---

## Step 2: Docker Compose

We used **Docker Compose** to run containers:
```yaml
version: "3.3"
services:
  web:
    build: .
    ports:
      - "8000:80"
```

**Explanation:**
- `web:` → Service name for the application.
- `build: .` → Builds Docker image from Dockerfile in current directory.
- `ports: "8000:80"` → Maps host port 8000 to container port 80.

> Now, you can access your app at `http://<EC2-Public-IP>:8000`.

---

## Step 3: Build and Run Docker
```bash
# Build Docker image
docker build -t task2-jenkins-app .

# Run Docker container
docker run -d -p 8000:80 task2-jenkins-app

# Check running container
docker ps
```

---

## Step 4: Push Docker Image to Docker Hub
```bash
# Login to Docker Hub
docker login

# Tag image for Docker Hub
docker tag task2-jenkins-app <your-dockerhub-username>/task2-jenkins-app:latest

# Push image
docker push <your-dockerhub-username>/task2-jenkins-app:latest
```

---

## Step 5: Jenkins CI/CD Pipeline Setup

### 1. Install Jenkins on EC2
```bash
sudo apt update
sudo apt install openjdk-21-jre
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```

### 2. Get Initial Jenkins Admin Password
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

- Use this password to unlock Jenkins in the browser (`http://<EC2-Public-IP>:8080`).

### 3. Add Jenkins User to Docker Group
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

- This allows Jenkins to run Docker commands without `sudo`.

### 4. Create Jenkins Job

- Go to Jenkins dashboard → **New Item** → Freestyle project.
- **Build step** → Execute shell:
```bash
# Pull latest code from GitHub
git clone https://github.com/Rohit001001/Task-2-Set-up-a-basic-Jenkins-pipeline-for-deploying-an-application.git

# Build Docker image
docker build -t task2-jenkins-app .

# Run container
docker run -d -p 8000:80 task2-jenkins-app
```

- **Optional:** Use `docker-compose up -d --build` if you have a `docker-compose.yml` file.

---

## Step 6: Access Application

- Docker Container → `http://<EC2-Public-IP>:8000`
- Jenkins Dashboard → `http://<EC2-Public-IP>:8080`

---

## Step 7: Notes / Tips

- Ensure **port 8000** is open in EC2 Security Groups.
- Remove running containers before re-deploying:
```bash
docker ps
docker kill <container-id>
docker rm <container-id>
```

- Jenkins user must have **Docker permissions** to avoid `sudo` password issues.

---

## Step 8: Summary

- Dockerized a static website using **Nginx**.
- Built **Docker Compose** file for easier container management.
- Configured **Jenkins CI/CD pipeline** for automated build and deployment.
- Deployed application on **EC2** and accessed it via `http://<EC2-IP>:8000`.

---

## Author

- **Name:** Rohit
- **GitHub:** [https://github.com/Rohit001001](https://github.com/Rohit001001)
- **Project:** Task-2: Jenkins CI/CD Docker Deployment

---

## License

This project is licensed under the terms included in the LICENSE.txt file.
