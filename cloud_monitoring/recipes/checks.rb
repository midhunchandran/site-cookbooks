#
# Cookbook Name:: cloud_monitoring
# Recipe:: default
#
# Copyright 2012, Rackspace
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'rackspace-monitoring'

cloud_monitoring_entity "#{node.hostname}" do
#  ip_addresses  'default_mon' => node[:ipaddress]
  metadata      'environment' => 'dev', :more => 'meta data'
  agent_id	node[:hostname]
  action :create
end

cloud_monitoring_check  "cpuhigh" do
  type                  'agent.cpu'
  period                30
  action :create
end

cloud_monitoring_alarm  "high cpu alarm" do
  check_label           'cpuhigh'
  criteria              'if (metric["usage_average"] <= 50) { return new AlarmStatus(OK); } return new AlarmStatus(WARNING);'
  notification_plan_id  'npuUeZXZQk'
  action :create
end

cloud_monitoring_check  "cpulow" do
  type                  'agent.cpu'
  period                30
  action :create
end

cloud_monitoring_alarm  "low cpu" do
  check_label           'cpulow'
  criteria              'if (metric["usage_average"] >= 0 && metric["usage_average"] < 3) { return new AlarmStatus(WARNING); } return new AlarmStatus(OK);'
  notification_plan_id  'npEAvodNa8'
  action :create
end

cloud_monitoring_check  "disk" do
  type                  'agent.disk'
  details               'target' => '/dev/xvda1'
  period                30
  action :create
end

cloud_monitoring_check  "network" do
  type                  'agent.network'
  details		'target' => 'eth0'
  period                30
  action :create
end

cloud_monitoring_check  "memory" do
  type                  'agent.memory'
  period                30
  action :create
end

#cloudmonitoring_check  "ping" do
#  target_alias          'default_mon'
#  type                  'remote.ping'
#  period                30
#  timeout               10
#  monitoring_zones_poll ['mzord']
#  action :create
#end

#cloudmonitoring_alarm  "ping alarm" do
#  check_label           'ping'
#  example_id            'remote.ping_packet_loss'
#  notification_plan_id  'npTechnicalContactsEmail'
#  action :create
#end

