//
//  PostsLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct PostsLayout: Layout, Codable {
    
    typealias Descriptor = PostsDescriptor
    
    struct Context {
        let postNumber: Int
        let contents: [Descriptor.Content]
    }
    
    var fields: [Field<Descriptor>]
    
    func fieldContext(for context: Context, contentIndex: Int) -> Descriptor.Context {
        Descriptor.Context(
            isFirst: contentIndex == 0,
            postNumber: context.postNumber,
            isVideo: context.contents.contains { $0.insights?.videoViews != nil && $0.insights?.videoViews != 0 },
            blockSize: context.contents.count
        )
    }
    
    private static var defaultFields: [Field<Descriptor>] = [Descriptor.url, .date, .likes, .comments, .saves, .engagement, .impressions, .reach, .videoViews, .mediaType, .postDate, .productType, .storyReplies, .storyExits, .storyTapsForward, .storyTapsBackward, .hashtags].map(Field.init)
    
    init(fields: [Field<Descriptor>] = defaultFields) {
        self.fields = fields
    }
}
