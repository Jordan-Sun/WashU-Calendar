//
//  JsonDataType.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/19.
//  Copyright © 2020 washu. All rights reserved.
//

import Foundation

struct JSONSchool: Codable {
    var fullName: String
    var shortName: String?
}

struct JSONSchoolResults: Codable {
    var page: Int
    var total_pages: Int
    var schools: [JSONSchool]
}

struct JSONDepartment: Codable {
    var fullName: String
    var shortName: String?
    var code: String
    
    var school: JSONSchool
}

struct JSONDepartmentResults: Codable {
    var school: JSONSchool?
    var page: Int
    var total_pages: Int
    var departments: [JSONDepartment]
}

struct JSONProfessor: Codable {
    var name: String
    
    var department: JSONDepartment
}

struct JSONProfessorResults: Codable {
    var department: JSONDepartment?
    var page: Int
    var total_pages: Int
    var professors: [JSONProfessor]
}

struct JSONSemester: Codable {
    var name: String
}

struct JSONSemesterResults: Codable {
    var page: Int
    var total_pages: Int
    var semesters: [JSONSemester]
}

struct JSONSession: Codable {
    var name: String
    
    var semester: JSONSemester
}

struct JSONSessionResults: Codable {
    var semester: JSONSemester?
    var page: Int
    var total_pages: Int
    var sessions: [JSONSession]
}

struct JSONAttribute: Codable {
    var name: String
    
    var courses: [JSONCourse]?
}

struct JSONAttributeResults: Codable {
    var course: JSONCourse?
    var page: Int
    var total_pages: Int
    var attributes: [JSONAttribute]
}

struct JSONCourse: Codable {
    var id: String
    var name: String
    var unit: Int
    
    var department: JSONDepartment
    var professor: JSONProfessor
    var session: JSONSession
    var attributes: [JSONAttribute]?
}

struct JSONCourseResultsByDepartment: Codable {
    var department: JSONDepartment?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONCourseResultsBySession: Codable {
    var session: JSONSession?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONCourseResultsByAttribute: Codable {
    var attribute: JSONAttribute?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONEvent: Codable {
    var name: String
    var start: Date
    var end: Date
    var location: String?
    
    var course: JSONCourse
}
