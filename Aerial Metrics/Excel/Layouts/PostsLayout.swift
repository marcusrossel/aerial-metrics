//
//  PostsLayout.swift
//  Aerial Metrics
//
//  Created by Marcus Rossel on 01.02.22.
//

struct PostsLayout: Layout, Codable {
    
    typealias Field = PostsField
    
    struct Context {
        let postNumber: Int
        let contents: [Field.Content]
    }
    
    var fields: [Field]
    
    func fieldContext(for context: Context, contentIndex: Int) -> Field.Context {
        Field.Context(
            isFirst: contentIndex == 0,
            postNumber: context.postNumber,
            isVideo: context.contents.contains { $0.insights?.videoViews != nil && $0.insights?.videoViews != 0 },
            blockSize: context.contents.count
        )
    }
    
    private static var defaultFields: [Field] = [.url, .date, .likes, .comments, .saves, .engagement, .impressions, .reach, .videoViews, .mediaType, .postDate, .productType, .storyReplies, .storyExits, .storyTapsForward, .storyTapsBackward, .hashtags]
    
    init(fields: [Field] = defaultFields) {
        self.fields = fields
    }
}
