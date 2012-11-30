
#import <EDCommon/EDCommon.h>
#import "NSCalendarDate+CCMAdditions.h"


@implementation NSCalendarDate(CCMAdditions)

- (NSString *)relativeDescriptionOfPastDate:(NSCalendarDate *)other
{
	int days, hours, mins;
	[self years:NULL months:NULL days:&days hours:&hours minutes:&mins seconds:NULL sinceDate:other];
	
	if(days > 1)
		return [NSString stringWithFormat:@"%d days ago", days];
	if(days == 1)
		return @"1 day ago";
	if(hours > 1)
		return [NSString stringWithFormat:@"%d hours ago", hours];
	if(hours == 1)
		return @"an hour ago";
	if(mins > 1)
		return [NSString stringWithFormat:@"%d minutes ago", mins];
	if(mins == 1)
		return @"a minute ago";
	return @"less than a minute ago";
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
    long interval = (long)timeInterval;
    NSString *sign = withSign ? ((interval < 0) ? @"-" : @"+") : @"";
    interval = abs(interval);

    if(interval > 3600)
        return [NSString stringWithFormat:@"%@%ld:%02ld:%02ld", sign, interval / 3600, (interval / 60) % 60, interval % 60];
    if(interval > 60)
        return [NSString stringWithFormat:@"%@%ld:%02ld", sign, interval / 60, interval % 60];
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
