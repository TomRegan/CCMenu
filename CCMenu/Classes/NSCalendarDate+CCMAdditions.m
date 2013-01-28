
#import <EDCommon/EDCommon.h>
#import "NSCalendarDate+CCMAdditions.h"


@implementation NSCalendarDate(CCMAdditions)

- (NSString *)relativeDescriptionOfPastDate:(NSCalendarDate *)other
{
	NSInteger days, hours, mins;
    NSString *description = [[[NSString alloc] initWithString:@"less than a minute ago"] autorelease];
	[self years:NULL months:NULL days:&days hours:&hours minutes:&mins seconds:NULL sinceDate:other];
	
	if (days > 1) {
		description = [NSString stringWithFormat:@"%li days ago", days];
    } else if (days == 1) {
		description = @"1 day ago";
    } else if (hours > 1) {
		description = [NSString stringWithFormat:@"%li hours ago", hours];
    } else if (hours == 1) {
		description = @"an hour ago";
    } else if (mins > 1) {
		description = [NSString stringWithFormat:@"%li minutes ago", mins];
    } else if (mins == 1) {
		description = @"a minute ago";
    }
    
	return description;
}

- (NSString *)descriptionOfIntervalWithDate:(NSCalendarDate *)other
{  
    return [self descriptionOfIntervalSinceDate:other withSign:NO];
}

- (NSString *)descriptionOfIntervalSinceDate:(NSCalendarDate *)other withSign:(BOOL)withSign
{
    return [[self class] descriptionOfInterval:[self timeIntervalSinceDate:other] withSign:withSign];
}

+ (NSString *)descriptionOfInterval:(NSTimeInterval)timeInterval withSign:(BOOL)withSign
{
    NSInteger interval = (NSInteger)timeInterval;
    NSString *sign = withSign ? ((interval < 0) ? @"-" : @"+") : @"";
    interval = ABS(interval);

    if(interval > 3600) {
        return [NSString stringWithFormat:@"%@%ld:%02ld:%02ld", sign, interval / 3600, (interval / 60) % 60, interval % 60];
    }
    if(interval > 60) {
        return [NSString stringWithFormat:@"%@%ld:%02ld", sign, interval / 60, interval % 60];
    }
    
    return [NSString stringWithFormat:@"%@%lds", sign, interval];
}


@end

@implementation NSDate(CCMAdditions)

- (NSString *)timeAsString
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    return [[dateFormatter stringFromDate:self] stringByRemovingSurroundingWhitespace];
}

@end
