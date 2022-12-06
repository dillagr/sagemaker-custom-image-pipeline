FROM continuumio/miniconda3:latest

# COPY environment.yml .
# RUN conda env update -f environment.yml --prune

RUN conda install -y -c anaconda python=3.7 pandas scikit-learn nltk numpy boto3 flask gevent gunicorn
RUN conda install -y -c conda-forge tqdm transformers sagemaker pandas smart_open
RUN conda install -y -c pytorch pytorch
