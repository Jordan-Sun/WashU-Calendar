//
//  JsonDataType.swift
//  WashU Calendar
//
//  Created by Zhuoran Sun on 2020/7/19.
//  Copyright © 2020 washu. All rights reserved.
//

import Foundation

struct JSONSchool: Codable, Hashable {
    var fullName: String
    var shortName: String? = nil
}

struct JSONSchoolResults: Codable, Hashable {
    var page: Int
    var total_pages: Int
    var schools: [JSONSchool]
}

struct JSONDepartment: Codable, Hashable {
    var fullName: String
    var shortName: String? = nil
    var code: String
    
    var school: JSONSchool
}

struct JSONDepartmentResults: Codable, Hashable {
    var school: JSONSchool?
    var page: Int
    var total_pages: Int
    var departments: [JSONDepartment]
}

struct JSONProfessor: Codable, Hashable {
    var name: String
    
    var department: JSONDepartment
}

struct JSONProfessorResults: Codable, Hashable {
    var department: JSONDepartment?
    var page: Int
    var total_pages: Int
    var professors: [JSONProfessor]
}

struct JSONSemester: Codable, Hashable {
    var name: String
}

struct JSONSemesterResults: Codable, Hashable {
    var page: Int
    var total_pages: Int
    var semesters: [JSONSemester]
}

struct JSONSession: Codable, Hashable {
    var name: String
    
    var semester: JSONSemester
}

struct JSONSessionResults: Codable, Hashable {
    var semester: JSONSemester?
    var page: Int
    var total_pages: Int
    var sessions: [JSONSession]
}

struct JSONAttribute: Codable, Hashable {
    var name: String
    
    var courses: [JSONCourse]?
}

struct JSONAttributeResults: Codable, Hashable {
    var course: JSONCourse?
    var page: Int
    var total_pages: Int
    var attributes: [JSONAttribute]
}

struct JSONCourse: Codable, Hashable {
    var id: String
    var name: String
    var unit: Int
    
    var department: JSONDepartment
    var professor: JSONProfessor
    var session: JSONSession
    var attributes: [JSONAttribute]?
}

struct JSONCourseResultsByDepartment: Codable, Hashable {
    var department: JSONDepartment?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONCourseResultsBySession: Codable, Hashable {
    var session: JSONSession?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONCourseResultsByAttribute: Codable, Hashable {
    var attribute: JSONAttribute?
    var page: Int
    var total_pages: Int
    var courses: [JSONCourse]
}

struct JSONEvent: Codable, Hashable {
    var name: String
    var start: Date
    var end: Date
    var location: String? = nil
    
    var course: JSONCourse
}
