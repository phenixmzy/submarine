#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Script for installing R / Python dependencies for Travis CI
set -exvuo pipefail
touch ~/.environ

# Install Python dependencies for Python specific tests
if [[ -n "${PYTHON:-}" ]] ; then
  wget https://repo.continuum.io/miniconda/Miniconda${PYTHON}-4.5.4-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p $HOME/miniconda
  echo "export PATH='$HOME/miniconda/bin:$PATH'" >> ~/.environ
  source ~/.environ

  hash -r
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a
  conda config --add channels conda-forge

  conda install numpy=1.13.3 pandas=0.21.1 matplotlib=2.1.1 pandasql=0.7.3 ipython=5.4.1 jupyter_client=5.1.0 ipykernel=4.7.0 bokeh=0.12.10
  pip install scipy==1.5.2 ggplot==0.11.5 grpcio==1.8.2 bkzep==0.4.0

  if [[ -n "${TENSORFLOW:-}" ]] ; then
    check_results=`conda search -c conda-forge tensorflow`
    echo "search tensorflow = $check_results"

    pip install tensorflow=="${TENSORFLOW}"
  fi
fi
