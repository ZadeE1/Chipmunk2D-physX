#import <XCTest/XCTest.h>
#import "ObjectiveChipmunk.h"

@interface ShapeTest : XCTestCase {}
@end

@implementation ShapeTest

#define TestAccessors(o, p, v) o.p = v; XCTAssertEqual(o.p, v, @"");

static void
testPropertiesHelper(id self, ChipmunkBody *body, ChipmunkShape *shape)
{
	XCTAssertNotEqual(shape.shape, NULL, @"");
	XCTAssertEqual(body, shape.body, @"");
	XCTAssertNil(shape.data, @"");
	XCTAssertFalse(shape.sensor, @"");
	XCTAssertEqual(shape.elasticity, (cpFloat)0, @"");
	XCTAssertEqual(shape.friction, (cpFloat)0, @"");
	XCTAssertEqual(shape.surfaceVel, cpvzero, @"");
	XCTAssertNil(shape.collisionType, @"");
	XCTAssertNil(shape.group, @"");
	XCTAssertEqual(shape.filter, CP_SHAPE_FILTER_ALL, @"");
	
	cpBB bb = [shape cacheBB];
	XCTAssertEqual(shape.bb, bb, @"");
	
	TestAccessors(shape, data, @"object");
	TestAccessors(shape, sensor, YES);
	TestAccessors(shape, elasticity, (cpFloat)0);
	TestAccessors(shape, friction, (cpFloat)0);
	TestAccessors(shape, surfaceVel, cpv(5,6));
	TestAccessors(shape, collisionType, @"type");
	cpShapeFilter f = {@"group", 456, 789};
	TestAccessors(shape, filter, f);
}

-(void)testProperties {
	ChipmunkBody *body = [ChipmunkBody bodyWithMass:1 andMoment:1];
	
	ChipmunkCircleShape *circle = [ChipmunkCircleShape circleWithBody:body radius:1 offset:cpv(1,2)];
	testPropertiesHelper(self, body, circle);
	XCTAssertEqual(circle.radius, (cpFloat)1, @"");
	XCTAssertEqual(circle.offset, cpv(1,2), @"");
	
	XCTAssertTrue([circle pointQuery:cpv(1,2)].distance <= 0.0f, @"");
	XCTAssertTrue([circle pointQuery:cpv(1,2.9)].distance <= 0.0f, @"");
	XCTAssertFalse([circle pointQuery:cpv(1,3.1)].distance <= 0.0f, @"");
	
	
	ChipmunkSegmentShape *segment = [ChipmunkSegmentShape segmentWithBody:body from:cpvzero to:cpv(1,0) radius:1];
	testPropertiesHelper(self, body, segment);
	XCTAssertEqual(segment.a, cpvzero, @"");
	XCTAssertEqual(segment.b, cpv(1,0), @"");
	XCTAssertEqual(segment.normal, cpv(0,-1), @"");
	
	XCTAssertTrue([segment pointQuery:cpvzero].distance <= 0.0f, @"");
	XCTAssertTrue([segment pointQuery:cpv(1,0)].distance <= 0.0f, @"");
	XCTAssertTrue([segment pointQuery:cpv(0.5, 0.5)].distance <= 0.0f, @"");
	XCTAssertFalse([segment pointQuery:cpv(0,3)].distance <= 0.0f, @"");
	
	ChipmunkPolyShape *poly = [ChipmunkPolyShape boxWithBody:body width:10 height:10 radius:0.0f];
	testPropertiesHelper(self, body, poly);
	XCTAssertTrue([poly pointQuery:cpv(0,0)].distance <= 0.0f, @"");
	XCTAssertTrue([poly pointQuery:cpv(3,3)].distance <= 0.0f, @"");
	XCTAssertFalse([poly pointQuery:cpv(-10,0)].distance <= 0.0f, @"");
	
	// TODO should add segment query tests
}

-(void)testSpace {
	// TODO
}

@end