# Dockerfile ligger i app mappen, fordi dette er en deploybar enhet, altså en selvstendig app eller service
# som pakker og kjøres separat

#start with a lightweight linux machine with python 3.12 installed
FROM python:3.12-slim 

#every command will be run in the /app directory (like cd /app)
WORKDIR /app

#copy dependency files first for better docker layer caching
COPY requirements.txt .

#runs command under build, result is saved in the image, so we can use it later when we run the container
RUN pip install --no-cache-dir -r requirements.txt

#copy the application source into the container
COPY main.py .

# non-root user (OpenShift friendly) - creates a new user named "appuser" with no password and no additional information (gecos)
# non-root is good because in prod it is not about maxium freedom like how development environment is, but about security, 
#if the container is compromised, we want to limit the damage that can be done, and running as non-root user is a good practice to achieve that
RUN adduser --disabled-password --gecos "" appuser
USER appuser

#tell that the container will listen on port 8000 when it runs, i still have to specify in docker run command to map the port to the host machine, but this is a good practice to document which port the application will use
EXPOSE 8000

#specifies the command to run when the container starts, in this case it will start the uvicorn server and run the FastAPI application defined in main.py, it will listen on all network interfaces (
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
