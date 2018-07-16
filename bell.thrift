/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

namespace java org.hillinsight.thrift

/**
* 人员属性信息
* 有些厂商为保证实时性，进店时间和人员属性是分别推送的，所以出现了这个表
* key: person_id+zone_name
*/
struct PersonAttribute {
    1:required i64 person_id,  // 基于人脸的ID
    2:optional i32 sex,
    3:optional i32 age,
	4:required string zone_name,   // 店名
}

/**
* 根据tracking_id来判断是属于同一个track
* person_id 用来关联event表或attribute表
* key: tracking_id +person_id +time
*/
struct TrackingNode {
    1:required i64 tracking_id,  // 当前轨迹ID 用来标记是否是一次进店的轨迹，用作算动线
    2:required i64 person_id,
    3:required i64 time,         // 时间，ms
    4:optional string identity,  // 内部键值，用来标识人脸身份 已废弃
    5:optional i32 x,
    6:optional i32 y, //因暂时未二维坐标，该字段暂不用
    7:optional i32 z,
	8:required string zone_name,   // 店名
	9:optional i32 personType,       // 0 普通人  1 店员
}

/**
* key:event+time+person_id+zone_name
* 事件表 包括进店 出店 途径 收银台前出现
* 如果事件发生时候属性未获取，可以利用attribute表再同步
*/
struct BellEvent {
    1:required  string  event,  // 事件类型 IN_EVENT OUT_EVENT POS_EVENT CROSS_EVENT
	2:required  i64    person_id,
	3:required  i64    time,
	4:required  string zone_name,
	5:optional  i32    age,
	6:optional  i32    sex,  // 0:男  1:女
	7:optional  string face_snap_img_url, //抓拍人脸图URL
	8:optional  string face_matched_img_url,//匹配到的人脸图URL
 	9:optional  string frame_snap_img_url //抓拍帧URL
}

enum Status {
  OK,
  FAILED,
  ERROR,
  UNKNOWN
}

service BellProtocol {
      Status insertPersonAttribute(1: PersonAttribute event,2: i64 time),
      Status insertPersonAttributeBatch(1: list<PersonAttribute> events,2: i64 time)
      Status delPersonAttribute(1: PersonAttribute event,2: i64 time),
      Status delPersonAttributeBatch(1: list<PersonAttribute> events,2: i64 time)
      Status updatePersonAttribute(1: PersonAttribute event,2: i64 time)
      Status updatePersonAttributeBatch(1: list<PersonAttribute> events,2: i64 time)

      Status insertTrackingNode(1: TrackingNode event,2: i64 time),
      Status insertTrackingNodeBatch(1: list<TrackingNode> events,2: i64 time)
      Status delTrackingNode(1: TrackingNode event,2: i64 time),
      Status delTrackingNodeBatch(1: list<TrackingNode> events,2: i64 time)
      Status updateTrackingNode(1: TrackingNode event,2: i64 time),
      Status updateTrackingNodeBatch(1: list<TrackingNode> events,2: i64 time)

      Status insertBellEvent(1: BellEvent event,2: i64 time),
      Status insertBellEventBatch(1: list<BellEvent> events,2: i64 time)
      Status delBellEvent(1: BellEvent event,2: i64 time),
      Status delBellEventBatch(1: list<BellEvent> events,2: i64 time)
      Status updateBellEvent(1: BellEvent event,2: i64 time),
      Status updateBellEventBatch(1: list<BellEvent> events,2: i64 time)
}
